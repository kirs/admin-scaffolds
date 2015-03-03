class Admin::<%= file_name.classify.pluralize %>Controller < Admin::BaseController
  inherit_resources

  <% if options[:actions].present? %>
  actions <%= options[:actions].map {|a| ":#{a}"}.join(", ") %>
  <% else %>
  actions :all, except: [:show]
  <% end %>


  private

  def collection
    @<%= file_name.pluralize %> ||= end_of_association_chain.page(params[:page]).per(20)
  end

end
