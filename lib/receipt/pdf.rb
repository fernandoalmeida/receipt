# -*- coding: utf-8 -*-
require 'ostruct'
require 'i18n'

module Receipt
  class Pdf
    extend Forwardable

    include Prawn::View

    attr_reader :params, :errors

    def_delegators :I18n, :t, :l

    def_delegators :params, *[
      :id,
      :payer,
      :receiver,
      :amount,
      :date,
      :currency,
      :description,
      :logo,
      :location,
      :locale,
      :filepath
    ]

    def initialize(params)
      @params = OpenStruct.new(params)
      setup_i18n

      @errors = {}
    end

    def data
      return unless valid?

      generate
      render
    end

    def file
      return unless valid?

      @file ||= lambda do
        generate
        save_as(path)
        path
      end.call
    end

    def before_receipt_box(&block)
      @before ||= block
    end

    def after_receipt_box(&block)
      @after ||= block
    end

    def valid?
      [
        :id,
        :amount,
        :payer,
        :receiver,
        :description
      ].each do |p|
        @errors[p] = 'required param not found' if params.send(p).to_s.empty?
      end

      @errors.size == 0
    end

    private

    def generate
      valid?

      before_receipt_box.call if before_receipt_box

      move_down 20
      receipt_box

      move_down 20
      after_receipt_box.call if after_receipt_box
    end

    def header
      pad(10) do
        text(t(:receipt).upcase, align: :center, style: :bold, size: 20)

        move_up 20
        text("#{t(:number)}: <b>#{id}</b>", inline_format: true)

        move_up 15
        text("#{t(:amount)}: <b>#{formated_amount}</b>",
             inline_format: true, align: :right)
        pad(10) { stroke_horizontal_rule }
      end
    end

    def body
      text(
        [
          "#{t(:received_from)} <b>#{payer}</b>",
          "#{t(:the_amount_of)} <b>#{formated_amount}</b>",
          "#{t(:relating_to)} <b>#{description}</b>."
        ].join(' '),
        inline_format: true
      )
    end

    def footer
      move_cursor_to 70
      stroke_horizontal_rule

      pad(35) do
        position = cursor
        width = bounds.width / 2

        date_box(0, position, width)
        signature_box(width, position, width)
      end
    end

    def formated_amount
      [
        currency,
        amount
      ].compact.join(' ')
    end

    def date_box(x, y, width)
      bounding_box [x, y], width: width do
        text(
          [
            location,
            l(date, format: :long)
          ].compact.join(', ')
        )
      end
    end

    def receipt_box
      padded_bounding_box(10, [30, cursor], width: 500, height: 250) do
        header
        body
        footer
      end
    end

    def signature_box(x, y, width)
      bounding_box [x, y], width: width do
        stroke_horizontal_rule
        move_down 10
        centered_text(receiver)
      end
    end

    def centered_text(s)
      text(s, align: :center)
    end

    def padded_bounding_box(padding, *args)
      bounding_box(*args) do
        stroke_bounds

        bounding_box(
          [padding, bounds.height - padding],
          width: bounds.width - (2 * padding),
          height: bounds.height - (2 * padding)
        ) do
          yield
        end
      end
    end

    def setup_i18n
      load_translations
      set_locale
    end

    def load_translations
      I18n.load_path += Dir[File.expand_path('config/locale/*.yml')]
      I18n.backend.load_translations
    end

    def set_locale
      I18n.locale = (locale || I18n.default_locale)
    end

    def path
      @path ||= (params.filepath || tempfilepath)
    end

    def tempfilepath
      @tempfilepath ||= File.join(
        Dir.tmpdir,
        Dir::Tmpname.make_tmpname("#{t(:receipt)}", "#{id}.pdf")
      )
    end
  end
end
