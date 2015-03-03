class AdminResourceGenerator < Rails::Generators::NamedBase
  INVISIBLE_ACTIONS = %w(create update destroy)

  source_root File.expand_path('../templates', __FILE__)

  argument :attributes, type: :array, default: []
  class_option :actions, type: :array, default: []

  def copy_controller_file
    template "controller.rb", "app/controllers/admin/#{file_name.pluralize}_controller.rb"

    views = if options[:actions].present?
      options[:actions] + ["_form"]
    else
      %w(index _form edit new)
    end

    views.each do |template_file|
      next if INVISIBLE_ACTIONS.include?(template_file)

      template "views/#{template_file}.html.erb", "app/views/admin/#{file_name.pluralize}/#{template_file}.html.slim"
    end

    if options[:actions].present?
      rule = options[:actions].map { |a| ":#{a}" }.join(", ")
      rule = "only: #{rule}"
    else
      rule = "except: :show"
    end

    puts "now you can add 'resources :#{file_name.underscore.pluralize}, #{rule}' to routes"
  end
end
