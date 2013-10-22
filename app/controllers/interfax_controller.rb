require 'require_all'
require "wash_out/soap"
require_all __dir__ + "/interfax"


class InterfaxController < ApplicationController
  soap_service namespace: 'urn:PhaxioApiProxy'

  soap_action "Sendfax", :args => { :Sendfax => Sendfax }, :return => SendfaxResponse
  include Interfax::SendfaxAction

  soap_action "SendCharFax", :args => { :SendCharFax => SendCharFax }, :return => SendCharFaxResponse
  include Interfax::SendCharFaxAction

  soap_action "GetFaxImage", :args => { :GetFaxImage => GetFaxImage }, :return => GetFaxImageResponse
  include Interfax::GetFaxImageAction

  soap_action "CancelFax", :args => { :CancelFax => CancelFax }, :return => CancelFaxResponse
  include Interfax::CancelFaxAction

end

