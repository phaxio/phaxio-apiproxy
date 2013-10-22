require "wash_out/soap"

class Sendfax < WashOut::Type
  map(
    :Username => :string,
    :Password => :string,
    :FaxNumber => :string,
    :FileData => :base64Binary,
    :FileType => :string
  )
end

class SendfaxResponse < WashOut::Type
  map :SendfaxResponse => { :SendfaxResult => :int }
end

module Interfax
  module SendfaxAction
    def Sendfax
      Phaxio.config do |config|
        config.api_key = params['Sendfax']['Username']
        config.api_secret = params['Sendfax']['Password']
      end

      file = Tempfile.new(['tempFax', "." + params['Sendfax']['FileType'].downcase], :encoding => 'ascii-8bit')
      faxId = nil

      begin
        file.write(Base64.decode64(params['Sendfax']['FileData']))
        file.rewind
        fax = Phaxio.send_fax(
            to: params['Sendfax']['FaxNumber'], filename: file
        )

        if fax['success']
          faxId = fax['faxId']
        else
          faxId = -1
        end

      rescue
        faxId = -1
      ensure
        file.close
        file.unlink
      end

      render :soap => {:SendfaxResponse => {:SendfaxResult => faxId } }
    end
  end
end