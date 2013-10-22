require "wash_out/soap"

class CancelFax < WashOut::Type
  map(
    :Username => :string,
    :Password => :string,
    :TransactionID => :integer
  )
end

class CancelFaxResponse < WashOut::Type
  map :CancelFaxResponse => {
      :CancelFaxResult => :integer
  }
end

module Interfax
  module CancelFaxAction
    def CancelFax

      Phaxio.config do |config|
        config.api_key = params['CancelFax']['Username']
        config.api_secret = params['CancelFax']['Password']
      end

      resultCode = -1
      result = Phaxio.cancel_fax(id: params['CancelFax']['TransactionID'])

      if result['success']
        resultCode = 0
      end

      render :soap => {:CancelFaxResponse => { :CancelFaxResult => resultCode } }
    end
  end
end