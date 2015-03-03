describe Receipt::Pdf do
  subject(:receipt) { described_class.new(params) }

  describe '#initialize' do
    let(:params) do
      {
        id: 1,
        date: date,
        amount: 100.0,
        currency: '$',
        payer: 'Chucky Norris',
        receiver: 'Fernando Almeida',
        description: 'Transaction #123',
        logo: 'logo.png'
      }
    end

    let(:date) { Time.now.strftime('%d/%m/%Y') }

    let(:missing_required_param_error) { Receipt::MissingRequiredParamError }

    it { expect(subject.id).to eq(1) }
    it { expect(subject.date).to eq(date) }
    it { expect(subject.amount).to eq(100.0) }
    it { expect(subject.currency).to eq('$') }
    it { expect(subject.payer).to eq('Chucky Norris') }
    it { expect(subject.receiver).to eq('Fernando Almeida') }
    it { expect(subject.description).to eq('Transaction #123') }
    it { expect(subject.logo).to eq('logo.png') }

    context 'when a required param is not passed' do
      [:id, :amount, :payer, :receiver, :description].each do |p|
        it "validates the presence of #{p}" do
          params.delete(p)

          expect { subject }
            .to raise_error(missing_required_param_error)
            .with_message("key not found: :#{p}")
        end
      end
    end

    context 'when an optional param is not passed' do
      [:date, :currency, :logo].each do |p|
        it "does not validate the presence of #{p}" do
          params.delete(p)

          expect { subject }.not_to raise_error
        end
      end
    end
  end
end
