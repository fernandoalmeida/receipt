module Receipt
  class MissingRequiredParamError < StandardError; end

  class Pdf
    include Prawn::View

    attr_reader :id,
                :payer,
                :receiver,
                :amount,
                :date,
                :currency,
                :description,
                :logo

    def initialize(params)
      @id = params.fetch(:id)
      @description = params.fetch(:description)
      @payer = params.fetch(:payer)
      @receiver = params.fetch(:receiver)
      @amount = params.fetch(:amount)
      @date = params.fetch(:date, Time.now.strftime('%d/%m/%Y'))
      @currency = params.fetch(:currency, '$')
      @logo = params.fetch(:logo, nil)
    rescue KeyError => ex
      raise MissingRequiredParamError, ex.message
    end
  end
end
