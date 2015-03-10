describe Receipt::Pdf do
  subject(:receipt) { described_class.new(params) }

  let(:params) do
    {
      id: 1,
      date: date,
      amount: 100.0,
      currency: '$',
      payer: 'Chucky Norris',
      receiver: 'Fernando Almeida',
      description: 'Transaction #123',
      logo: 'logo.png',
      location: 'Sao Paulo',
      locale: :pt
    }
  end

  let(:date) { Time.now.to_date }

  describe '#initialize' do
    it { expect(receipt.id).to eq(1) }
    it { expect(receipt.date).to eq(date) }
    it { expect(receipt.amount).to eq(100.0) }
    it { expect(receipt.currency).to eq('$') }
    it { expect(receipt.payer).to eq('Chucky Norris') }
    it { expect(receipt.receiver).to eq('Fernando Almeida') }
    it { expect(receipt.description).to eq('Transaction #123') }
    it { expect(receipt.logo).to eq('logo.png') }
    it { expect(receipt.location).to eq('Sao Paulo') }
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
