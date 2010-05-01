class Posnet::Command::LBFSTRQ < Posnet::Command
  escp :checksum => true
  on_response_wait_for_trailing_escape

  def process_command
    "23#s"
  end

  def process_response(response)
    if response =~ /\eP1#X(.*)\e\\/
      res = $1.split "/"
      params = parse_params(res.shift)
      status = parse_numbers(res)
      status.merge! params
      return status
    else "error: #{response}"
    end
  end

  def parse_params(params)
    array = params.split(";")
    flag = lambda { |i| (array[i].to_i == 1 ? true : false) }
    {
      :error => array[0].to_i,
      :fiscal => flag.call(1),
      :transaction_now => flag.call(2),
      :trf_flag => flag.call(3),
      :ram_reset_count => array[5].to_i
    }
  end

  def parse_numbers(numbers)
    unique_id = numbers.pop
    cash_status = numbers.pop.to_f
    tot_g = numbers.pop.to_f

    ptu_count = numbers.count / 2
    ptus = numbers.shift ptu_count
    par_num = numbers.shift
    tots = numbers
    
    
    ptu = {}
    [:a, :b, :c, :d, :e, :f].each_with_index do |x, i|
      if i < ptu_count
        ptu[x] = {
          :value => ptus[i].to_f,
          :total => tots[i].to_f
        }
      end
    end
    ptu[:g] = {:value => 0.0, :total => tot_g}

    {
      :unique_id => unique_id,
      :cash_status => cash_status,
      :par_num => par_num,
      :ptu => ptu,
    }
  end
end