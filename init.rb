require_relative 'lib/issue_docs/create_google_doc'

Redmine::Plugin.register :issue_docs do
  name 'Issue Docs plugin'
  author 'rublen'
  description 'Creates a new Google document while creating a new issue in Redmine and puts share link for the doc to Custom field of the issue'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'https://github.com/rublen'
end

new_custom_field = IssueCustomField.find_or_initialize_by(name: 'Google document')

unless new_custom_field.persisted?
  new_custom_field.update(
    field_format: "link",
    is_for_all: true,
    description: "Google document related to this issue"
  )
  new_custom_field.trackers=Tracker.all
end

class ControllerIssuesNewAfterSaveHook < Redmine::Hook::ViewListener
  include IssueDocs::CreateGoogleDoc

  def controller_issues_new_after_save(context={})
    @created_issue = context[:issue]
    @created_issue.custom_values.find_or_create_by(custom_field_id: @@doc_field).update(value: value_for_custom_field)
  end

  private

  def value_for_custom_field
    authorize
    file = create_document(doc_name)
    permit_anyone_to_edit file
    edit_link_for file
  end

  def doc_name
    "#{Time.now.to_i}-#{@created_issue.subject[0..20]}"
  end
end

ControllerIssuesNewAfterSaveHook.class_variable_set(:@@doc_field, new_custom_field)
