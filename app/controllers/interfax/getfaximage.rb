require "wash_out/soap"

class GetFaxImage < WashOut::Type
  map(
    :Username => :string,
    :Password => :string,
    :TransactionID => :integer,
    :Image => :base64Binary
  )
end

class GetFaxImageResponse < WashOut::Type
  map :GetFaxImageResponse => {
      :GetFaxImageResult => :integer,
      :Image => :base64Binary
  }
end

module Interfax
  module GetFaxImageAction
    def GetFaxImage
      Phaxio.config do |config|
        config.api_key = params['GetFaxImage']['Username']
        config.api_secret = params['GetFaxImage']['Password']
      end

      pdfFile = Tempfile.new(['faximage', '.pdf'], :encoding => 'ascii-8bit')
      tiffFile = Tempfile.new(['tiffimage', '.tiff'], :encoding => 'ascii-8bit')
      tiffFile.close

      imageResult = -1
      data = ''

      begin
        pdfFileData = Phaxio.get_fax_file(id: params['GetFaxImage']['TransactionID'])

        begin
          parsed = JSON.parse(pdfFileData.body)

          if parsed
            raise parsed['message']
          end
        rescue JSON::ParserError
          # do nothing, this is ok
        end

        pdfFile.write(pdfFileData)
        pdfFile.close

        result = `gs -q -dNOPAUSE -dBATCH -sDEVICE=tiffg3 -sPAPERSIZE=letter -sOutputFile=#{ tiffFile.path } #{ pdfFile.path }`

        data = File.read(tiffFile.path)

        imageResult = 0

      rescue
        imageResult = -1
      ensure
        pdfFile.close!
        tiffFile.close!
      end

      render :soap => {:GetFaxImageResponse => {:GetFaxImageResult => imageResult, :Image => Base64.encode64(data) } }
    end
  end
end