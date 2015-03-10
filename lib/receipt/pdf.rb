# -*- coding: utf-8 -*-
require 'ostruct'
require 'i18n'

module Receipt
  class MissingRequiredParamError < StandardError; end
  class Pdf
    extend Forwardable

    include Prawn::View

    attr_reader :params, :filepath, :errors

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
      @filepath = @params.filepath || tempfilepath
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

    def tempfilepath
      @tempfilepath ||= File.join(
        Dir.tmpdir,
        Dir::Tmpname.make_tmpname("#{t(:receipt)}", "#{id}.pdf")
      )
    end
  end
end
