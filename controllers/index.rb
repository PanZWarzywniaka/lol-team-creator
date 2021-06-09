get "/" do
    redirect "/index"
end


get "/index" do

    erb :index
end

post "/index" do

    @num_of_teams = params.fetch("num_of_teams",1).strip.to_i
    server = params.fetch("server","eune").strip
    puts "Number of teams to be generated #{@num_of_teams}"
    @nicks = fetchSummoners(params)
    puts @nicks
    @ratings = getAllMMRs(server)
    puts @ratings
    @teams = getOptimizedTeams()

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

def getSummonersMMR(name,server)

    response = HTTParty.get("https://#{server}.whatismymmr.com/api/v1/summoner?name=#{name}")
    puts
    puts "Checking MMR of #{name}... on #{server}"

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

def getAllMMRs(server)
    map = Hash.new
    @nicks.each do |name|
        map[name] = getSummonersMMR(name,server)
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
        sum+=@ratings[name] unless @ratings[name].nil?

    end
    
    return sum/teamArray.size()
end

def getOptimizedTeams()
    iterativeApproach()
    #pickBestApproach()
end

def iterativeApproach()

    desired_rating = getDesiredRating()
    allTeamCombinations = getAllTeamCombinations(desired_rating)

    #sroting team records
    allTeamCombinations = allTeamCombinations.sort_by { |team, rating_diff| rating_diff }

    puts "Desired rating is #{desired_rating}"

    team_records = []

    #creating team_records
    for i in 0...@num_of_teams
        team_records << allTeamCombinations[i]
    end

    puts "#{@num_of_teams} teams were calculated"
    puts
    puts
    puts "Teams were choosen!"
    puts
    team_records.each_with_index do |team, num|
        puts "Team number: #{num+1}."
        puts
        team[0].each_with_index do |name, index|
            puts "Team member no. #{index+1}: #{name}"
        end
        puts
        puts "Diff between teams #{team[1]}"
        puts
    end
    


    return team_records

end

def getAllTeamCombinations(desired_rating)
    data = @nicks
    output = Hash.new
    k=5
    for i1 in 0..data.size()-k
        for i2 in i1+1..data.size()-k+1
            for i3 in i2+1..data.size()-k+2
                for i4 in i3+1..data.size()-k+3
                    for i5 in i4+1..data.size()-k+4
                        team = [data[i1],data[i2],data[i3],data[i4],data[i5]]
                        output[team] = (sumTeamMMR(team)-desired_rating).abs()

                    end
                end
            end
        end
    end
    output
end

def getDesiredRating()
    sum=0
    @ratings.each do |name,value|
        sum+=value unless value.nil?
    end
    sum/2.floor()
end