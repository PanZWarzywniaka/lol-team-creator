get "/" do
    redirect "/index"
end


get "/index" do

    erb :index
end

post "/index" do

    @nicks = ["Qertes","Muffinek137","Queen456","MagnatZOwocniaka"]
    @nicks = fetchSummoners(params)
    puts @nicks
    @ratings = getAllMMRs(@nicks)

    #@teams [nick1,nick2,nick2,nick3] => team mmr
    @team1 = ["Qertes","Muffinek137","Queen456","MagnatZOwocniaka","balti24"]
    puts "team1 mmr #{sumTeamMMR(@team1)}"
    puts @ratings
    erb :index
end

def fetchSummoners(params)
    ret = Array.new
    for i in 0..9 do

        name = params["summoner_#{i}"]
        puts "Summoner number #{i+1}: #{name}"
        ret[i] = name
    end

    puts ret
    ret
end

def getSummonersMMR(name)

    response = HTTParty.get("https://eune.whatismymmr.com/api/v1/summoner?name=#{name}")
    puts
    puts "Checking MMR of #{name}..."

    if response.code == 200
        parsed = JSON.parse(response.body)
        if !parsed["ranked"]["avg"].nil?
            rating = parsed["ranked"]["avg"]
            puts "#{name} ranked rating is #{rating}"
        elsif !parsed["normal"]["avg"].nil?

            rating = parsed["normal"]["avg"]
            puts "#{name} normal rating: #{rating}"

        else
            puts "#{name} not known rating"
            rating = nil
        end

        return rating
    else
        puts "Erorr"
        return nil
    end
end

def getAllMMRs(nicks)
    map = Hash.new
    nicks.each do |name|
        map[name] = getSummonersMMR(name)
    end
    return map
end

def sumTeamMMR(teamArray)
    sum = 0
    if(teamArray.size()!=5)
        puts "Team doesn't have 5 players"
    else
        teamArray.each do |name|
            if @ratings[name].nil?
                sum+=averageTeamMMR(teamArray)
            else
                sum+=@ratings[name]
            end
        end

    end
    
    return sum 
end

def averageTeamMMR(teamArray)

    sum = 0
    teamArray.each do |name|
        sum+=@ratings[name]
    end
    
    return sum/teamArray.size()
end