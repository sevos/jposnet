require 'rubygems'
require 'sinatra'
require 'posnet'
require 'haml'

def hashinize_params
  new_params = {}
  params.each_pair do |full_key, value|
    this_param = new_params
    split_keys = full_key.split(/\]\[|\]|\[/)
    split_keys.each_index do |index|
      break if split_keys.length == index + 1
      this_param[split_keys[index]] ||= {}
      this_param = this_param[split_keys[index]]
    end
    this_param[split_keys.last] = value
  end
  request.params.replace new_params
end

def require_printer
  $printer ||= Posnet::Printer.new(@port_file_path) if @port_file_path
  unless $printer and $printer.initialized? or request.path_info == "/config"
    redirect "/config" and halt
  end
end

before do
  hashinize_params
  require_printer
end

get "/" do
  @printer = $printer
  @printer_status = $printer.status
  if @printer_status && @printer_status[:online]
    @lbfstrq = $printer.execute(:lbfstrq)
  end
  haml :index
end

get "/config" do
  @port_names = Posnet::Printer.serial_port_names
  haml :config
end

post '/config' do
  @port_file_path = request.params["port_name"]
  response.set_cookie("port_file_path", @port_file_path)
  $printer = Posnet::Printer.new(@port_file_path)
  redirect "/"
end

post "/cash_status" do
  $printer.cash_status
  redirect "/"
end

post "/cash_in" do
  $printer.execute :lbinccsh, request.params["amount"].to_f
  redirect "/"
end

post "/cash_out" do
  $printer.execute :lbdeccsh, request.params["amount"].to_f
  redirect "/"
end

get "/set_header" do
  haml :set_header
end

post "/set_header" do
  $printer.set_header request.params["header"].to_s[0,500]
  redirect "/"
end

post "/disconnect" do
  $printer.close if $printer.initialized?
  $printer = nil
  response.delete_cookie("port_file_path")
  redirect "/config"
end