SimpleNavigation::Configuration.run do |navigation|  
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.dom_class = 'nav'
    primary.item :tasks, 'Tasks', url('/tasks') do |tasks|
      tasks.dom_class = 'nav nav-pills'
      tasks.item :pending, "Pending <span class=\"badge\">#{task_count}</span>", url('/tasks/pending')
      tasks.item :waiting, 'Waiting', url('/tasks/waiting')
      tasks.item :completed, 'Completed', url('/tasks/completed')
      tasks.item :deleted, 'Deleted', url('/tasks/deleted')
    end
    primary.item :projects, 'Projects', url('/projects'), { :highlights_on => %r{/projects/?.+?} } do |projects|
      projects.dom_class = 'nav nav-pills'
      projects.item :overview, 'Overview', url('/projects/overview')
    end
  end
end
