require "wash_out/soap"

class SendfaxResponse < WashOut::Type
  map :SendfaxResponse => {
      :SendfaxResult => :int
  }
end

class ApiController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  soap_action "Sendfax",
              :args   => { :Sendfax => { :a => :string, :b => :string } },
              :return => SendfaxResponse
  def Sendfax
    render :soap => { :SendfaxResponse => {:SendfaxResult => 1234 }}
  end

  before_filter :dump_parameters
  def dump_parameters
    logger.debug params.inspect
  end
end

