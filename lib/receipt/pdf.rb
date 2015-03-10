require 'ostruct'
module Receipt
  class MissingRequiredParamError < StandardError; end

  class Pdf
    extend Forwardable

    include Prawn::View

    attr_reader :params, :filepath

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
      @filepath = @params.filepath || tempfilepath
    end

    def tempfilepath
      @tempfilepath ||= File.join(
        Dir.tmpdir,
        Dir::Tmpname.make_tmpname("#{t(:receipt)}", "#{id}.pdf")
      )
    end
  end
end
