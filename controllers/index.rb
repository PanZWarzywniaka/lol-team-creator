get "/" do
    redirect "/index"
end


get "/index" do
    erb :index
end

post "/index" do

    map = fetchSummoners(params)


    redirect "/index"
end

def fetchSummoners(params)
    ret = Hash.new


    for i in 0..9 do

        name = params["summoner_#{i}"]
        puts "Summoner number #{i+1}: #{name}"
        ret[name] = nil
    end

    puts ret
    ret
end