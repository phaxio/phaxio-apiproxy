require "wash_out/soap"

class SendCharFax < WashOut::Type
  map(
    :Username => :string,
    :Password => :string,
    :FaxNumber => :string,
    :Data => :string,
    :FileType => :string
  )
end

class SendCharFaxResponse < WashOut::Type
  map :SendCharFaxResponse => { :SendCharFaxResult => :int }
end

module Interfax
  module SendCharFaxAction
    def SendCharFax
      Phaxio.config do |config|
        config.api_key = params['SendCharFax']['Username']
        config.api_secret = params['SendCharFax']['Password']
      end

      faxId = nil

      if params['SendCharFax']['FileType'].downcase == 'html'
        stringDataType = 'html'
      else
        stringDataType = 'text'
      end

      fax = Phaxio.send_fax(
          to: params['SendCharFax']['FaxNumber'],
          string_data: params['SendCharFax']['Data'],
          string_data_type: stringDataType
      )

      if fax['success']
        faxId = fax['faxId']
      else
        faxId = -1
      end

      render :soap => {:SendCharFaxResponse => {:SendCharFaxResult => faxId } }
    end
  end
end