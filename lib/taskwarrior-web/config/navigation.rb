SimpleNavigation::Configuration.run do |navigation|  
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.dom_class = 'nav'
    primary.item :tasks, 'Tasks', '/tasks' do |tasks|
      tasks.dom_class = 'nav nav-pills'
      tasks.item :pending, "Pending <span class=\"badge\">#{task_count}</span>", '/tasks/pending'
      tasks.item :waiting, 'Waiting', '/tasks/waiting'
      tasks.item :completed, 'Completed', '/tasks/completed'
      tasks.item :deleted, 'Deleted', '/tasks/deleted'
    end
    primary.item :projects, 'Projects', '/projects', { :highlights_on => %r{/projects/?.+?} } do |projects|
      projects.dom_class = 'nav nav-pills'
      projects.item :overview, 'Overview', '/projects/overview'
    end
  end
end
