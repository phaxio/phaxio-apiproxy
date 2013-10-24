require "wash_out/soap"

class FaxStatusEx < WashOut::Type
  map(
    :Username => :string,
    :Password => :string,
    :LastTransactionID => :integer,
    :MaxItems => :integer,
    :TotalCount => :integer,
    :ListSize => :integer,
    :ResultCode => :integer
  )
end

class FaxItemEx < WashOut::Type
  map(
    :ParentTransactionID => :integer,
    :TransactionID => :integer,
    :SubmitTime => :dateTime,
    :PostponeTime => :dateTime,
    :CompletionTime => :dateTime,
    :UserID => :string,
    :Contact => :string,
    :JobID => :string,
    :DestinationFax => :string,
    :ReplyEmail => :string,
    :RemoteCSID => :string,
    :PagesSent => :integer,
    :Status => :integer,
    :Duration => :integer,
    :Subject => :integer,
    :PagesSubmitted => :integer,
    :SenderCSID => :string,
    :Priority => :integer,
    :Units => :integer,
    :CostPerUnit => :integer,
    :PageSize => :string,
    :PageOrientation => :string,
    :PageResolution => :string,
    :RenderingQuality => :string,
    :PageHeader => :string,
    :RetriesToPerform => :integer,
    :TrialsPerformed => :integer
  )
end

class FaxStatusExResponse < WashOut::Type
  map :FaxStatusExResponse => {
      :TotalCount => :integer,
      :ListSize => :integer,
      :ResultCode => :integer,
      :FaxStatusExResult => [ FaxItemEx ]
  }
end

module Interfax
  module FaxStatusExAction
    def FaxStatusEx
      Phaxio.base_uri 'https://api-phaxio-com-2e76oayxu2or.runscope.net/v1'

      Phaxio.config do |config|
        config.api_key = params['FaxStatusExA']['Username']
        config.api_secret = params['FaxStatusExA']['Password']
      end


      #get the transaction id of the last fax, and get the requested time
      fax = Phaxio.get_fax_status(id: params['FaxStatusExA']['LastTransactionID'])

      totalCount = 0
      listSize = 0
      resultCode = -1
      faxData = []

      if fax['success']
        requestedAt = fax['data']['requested_at']

        #then get all faxes that have occurred before that, as limited by the filters
        faxes = Phaxio.list_faxes(start: 0, end: requestedAt, maxperpage: params['FaxStatusExA']['MaxItems'] )
        faxes = JSON.parse(faxes.body)

        if faxes['success']
          faxData = faxes['data'].map { |fax| self.faxItemFromPhaxioFax(fax) }
          pagingData = faxes['paging']

          listSize = faxData.length
          totalCount = pagingData['total_results']
          resultCode = 0
        end
      end

      render :soap => {
          :FaxStatusExResponse => {
            :TotalCount => totalCount,
            :ListSize => listSize,
            :ResultCode => resultCode,
            :FaxStatusExResult => faxData
          }
      }
    end

    def faxItemFromPhaxioFax(fax)
          return {
              :ParentTransactionID => 0,
              :TransactionID => fax['id'],
              :SubmitTime => DateTime.strptime(fax['requested_at'].to_s,'%s'),
              :PostponeTime => nil,
              :CompletionTime => DateTime.strptime(fax['completed_at'].to_s,'%s'),
              :UserID => 0,
              :Contact => '',
              :JobID => '',
              :DestinationFax => '',
              :ReplyEmail => '',
              :RemoteCSID => '',
              :PagesSent => fax['num_pages'],
              :Status => self.getFaxStatus(fax['status']),
              :Duration => (fax['completed_at'] - fax['requested_at']),
              :Subject => 0,
              :PagesSubmitted => fax['num_pages'],
              :SenderCSID => '',
              :Priority => 0,
              :Units => 0,
              :CostPerUnit => 0,
              :PageSize => '',
              :PageOrientation => '',
              :PageResolution => '',
              :RenderingQuality => '',
              :PageHeader => '',
              :RetriesToPerform => '',
              :TrialsPerformed => ''
          }
    end

    def getFaxStatus(status)
      case status
        when 'success'; 0
        when 'failure'; -1
        else -3
      end
    end
  end
end