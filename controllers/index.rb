get "/" do
    redirect "/index"
end


get "/index" do

    erb :index
end

post "/index" do

    #@nicks = ["Qertes","Muffinek137","Queen456","MagnatZOwocniaka","nickzdupy"]
    @nicks = fetchSummoners(params)
    puts @nicks
    @ratings = getAllMMRs()

    #@teams [nick1,nick2,nick2,nick3] => team mmr
    @team1 = ["Qertes","Muffinek137","Queen456","MagnatZOwocniaka","balti24"]
    puts "team1 mmr #{sumTeamMMR(@team1)}"
    puts @ratings

    @team = getOptimizedTeam()

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

def getAllMMRs()
    map = Hash.new
    @nicks.each do |name|
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
        sum+=@ratings[name] unless @ratings[name].nil?

    end
    
    return sum/teamArray.size()
end

def getOptimizedTeam()
    iterativeApproach()
    #pickBestApproach()
end

def iterativeApproach()

    desired_rating = getDesiredRating()
    allTeamCombinations = getAllTeamCombinations(desired_rating)
    
    allTeamCombinations.each do |team, rating_diff|
        puts
        puts team
        puts "How close to the desired rating: #{rating_diff}"
    end

    puts "Desired rating is #{desired_rating}"

    #geting team with lowest value

    team_record = allTeamCombinations.min_by { |team, rating_diff| rating_diff }
    puts
    puts
    puts "Team choosen!"
    team_record[0].each_with_index do |name, index|
        puts "Team member no. #{index}: #{name}"
    end
    puts "Diff between teams #{team_record[1]}"


    return team_record

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
    sum/2
end