require "wash_out/soap"
require "interfax/sendfax"


class InterfaxController < ApplicationController
  soap_service namespace: 'urn:PhaxioApiProxy'

  soap_action "Sendfax", :args => { :Sendfax => Sendfax }, :return => SendfaxResponse
  include Interfax::SendfaxAction

end

