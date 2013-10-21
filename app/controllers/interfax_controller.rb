require "wash_out/soap"

class InterfaxController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  soap_action "AnOperation",
              :args   => { :a => :string, :b => :string } },
              :return => :string
  def AnOperation
    render :soap => "done"
  end

  before_filter :dump_parameters
  def dump_parameters
    logger.debug params.inspect
  end
end