class Graph
  attr_reader :student_graph

  def initialize
    @student_graph = {}
    create_graph
  end

  def create_graph
    all_students = File.read('student_names.txt').split("\n")
    all_students.each do |student1|
      @student_graph[student1] = {}
      all_students.each do |student2|
        next if student1 == student2
        @student_graph[student1][student2] = 100
      end
    end
    @student_graph
  end

  def best_graph
    graphs = graphs_with_no_zeroes
    graphs.sort_by do |graph|
      graph.flatten.select { |el| el.is_a?(Integer) }.inject(:+)
    end
    graphs.last
  end

  def graphs_with_no_zeroes
    successful_graphs = []
    until successful_graphs.length >= 50
      pairings = through_graph_once
      pairings.flatten(1).each do |el|
        if el.is_a?(Integer) && el == 0
          next
        end
      end
      successful_graphs << pairings
    end
    successful_graphs
  end

  def through_graph_once
    #duplicate graph
    dup_graph = @student_graph.dup
    scores_and_pairs = []

    #until the dup is empty
    until dup_graph.keys.empty?

      #get a random pair, store the info
      scores_and_pairs << one_random_pair(dup_graph)

      #remove all references to those students from the graph
      remove_references(dup_graph, scores_and_pairs.last.last)
    end
    scores_and_pairs
  end

  def one_random_pair(dup_graph)
    person1 = dup_graph.keys.sample
    person2 = dup_graph[person1].keys.sample
    pairing = [person1, person2]
    score = dup_graph[person1][person2]
    [score, pairing]
  end

  def remove_references(dup_graph, pair)
    dup_graph.delete(pair[0])
    dup_graph.delete(pair[1])
    dup_graph.each do |key, value|
      value.each_key do |student|
        value.delete(student) if pair.include?(student)
      end
    end
    dup_graph
  end

end

if __FILE__ == $PROGRAM_NAME

  g = Graph.new
  g.fifty_possibilities.each { |arr| p arr; puts "\n" }






  # g.add_vertex('B', {'A' => 7, 'F' => 2})
  # g.add_vertex('C', {'A' => 8, 'F' => 6, 'G' => 4})
  # g.add_vertex('D', {'F' => 8})
  # g.add_vertex('E', {'H' => 1})
  # g.add_vertex('F', {'B' => 2, 'C' => 6, 'D' => 8, 'G' => 9, 'H' => 3})
  # g.add_vertex('G', {'C' => 4, 'F' => 9})
  # g.add_vertex('H', {'E' => 1, 'F' => 3})

end
