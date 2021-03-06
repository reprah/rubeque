namespace :problems do

  task :fix_underscores => :environment do
    problems = Problem.all
    count = 0
    seen = []
    problems.each do |p|
      if seen.include?(p.id)
        # for some reason, it sometimes updates the same problem twice
        puts "Skipping problem #{p}...\n"
        next
      end
      p.code = p.code.gsub("__", "___") unless p.code.blank?
      p.hidden_code = p.hidden_code.gsub("__", "___") unless p.hidden_code.blank?
      p.save!
      seen << p.id
      count+=1
    end
    puts "Updated #{count} problems"
  end

  task :link => :environment do
    problems = Problem.approved.all.sort_by {|p| [p.difficulty, (-1 * p.solutions.count)]}

    problems.each_with_index do |problem, i|
      problem.next_problem = problems[i+1] if problems[i+1]
      problem.save!
    end
  end
end
