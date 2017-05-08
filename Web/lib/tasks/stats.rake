namespace :spec do
  # largely lifted from http://www.pervasivecode.com/blog/2007/06/28/hacking-rakestats-to-get-gross-loc/
  task :stats_setup do
    require 'code_statistics'

    class CodeStatistics
      alias calculate_statistics_orig calculate_statistics
      def calculate_statistics
        @pairs.inject({}) do |stats, pair|
          if 3 == pair.size
            stats[pair.first] = calculate_directory_statistics(pair[1], pair[2]); stats
          else
            stats[pair.first] = calculate_directory_statistics(pair.last); stats
          end
        end
      end
    end
    ::STATS_DIRECTORIES = []
    ::STATS_DIRECTORIES << ['Views',  'app/views', /\.(rhtml|erb|rb)$/]
    ::STATS_DIRECTORIES << ['CSS',  'public', /\.css$/]
  end
end

namespace :stats do
  desc "Report code statistics (KLOCs, etc) for non-code like HTML and CSS from the application"
  task :static => ["spec:stats_setup", "stats"]
end