SessionTabs =  ->
SessionTabs.Helpers =
  setButtonToSubmit: (buttonDom) ->
    buttonDom.text(buttonDom.attr('value'))
    buttonDom.attr("value","Submitting...")
    buttonDom.attr('disabled', 'disabled')
  setButtonToEnabled: (buttonDom) ->
    buttonDom.attr('value', buttonDom.text())
    buttonDom.attr('disabled', '')
  addValidationError: (error, message) ->
    field_id = "user_#{error}"
    label = $("label[for='#{field_id}']")
    error = $("##{field_id}_validation")
    label.addClass('inline_validation_error')
    error.text(message[0])
    error.addClass('inline_validation_error')
  clearValidationErrors: ->
    $('span.inline_validation_error').text("")
    $('label').removeClass('inline_validation_error')
SessionTabs.bindNavigation = ->
  $('#main_tab_menu').tabs
    ajaxOptions:
      error: (xhr, status, index, anchor) ->
        $(anchor.hash).html("We're having trouble,  Please try again in a little while.")
      success: (data, status, xhr) ->
        SessionTabs.bindActions()
        SessionTabs.registrationForm.bind()
        SessionTabs.signinForm.bind()
        SessionTabs.newPasswordForm.bind()

SessionTabs.bindActions = ->
  $('.gotoLogin').click( ->
    $('#main_tab_menu').tabs('select',0)
    #console.log $('#main_tab_menu').tabs('options', 'selected')
  )

  $('.gotoSignup').click( ->
    $('#main_tab_menu').tabs('select',1)
  )

  $('.gotoForgotPassword').click( ->
    element = $('#main_tab_menu')
    if element.tabs('length') < 3
      element.tabs('add', '/users/password/new', 'Password reset')
    element.tabs('select', 2)
  )

SessionTabs.tabForm =
  bind: ->
    containerDom = $(this.containerSelector)
    formDom = $("#{this.containerSelector} form")
    buttonDom = $("#{this.containerSelector} form input[type='submit']")
    afterSuccess = this.afterSuccess || ->
    afterError = this.afterError || ->

    formDom.bind('ajax:beforeSend', ->
      SessionTabs.Helpers.setButtonToSubmit(buttonDom)
      SessionTabs.Helpers.clearValidationErrors()
    )
    
    formDom.bind('ajax:success', (event, data, success, xhr) ->
      SessionTabs.Helpers.setButtonToEnabled(buttonDom)
      afterSuccess(event, data, success, xhr)
    )

    formDom.bind('ajax:error', (evt, xhr, status, error) ->
      SessionTabs.Helpers.setButtonToEnabled(buttonDom)
      afterError(evt, xhr, status, error)
    )

  flash: (message_array) ->
    $("#{this.containerSelector} .flash").css("display", "block")
    text_div = $("#{this.containerSelector} .flash div")

    text = if message_array.notice then message_array.notice else message_array[0]
    text_div.text(text)
    text_div.hide().fadeIn("slow")



SessionTabs.registrationForm =
  containerSelector: '#registration_form_container'
  afterSuccess: (event, data, success, xhr) ->
    window.location = "/homepage"
  afterError: (event, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    for error, message of response
      SessionTabs.Helpers.addValidationError(error, message)
$.extend(SessionTabs.registrationForm, SessionTabs.tabForm)

SessionTabs.signinForm =
  containerSelector: '#signin_form_container'
  afterSuccess: (event, data, success, xhr) ->
    window.location = "/homepage"

  afterError: (event, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    if response.status == "unauthenticated"
      SessionTabs.signinForm.flash(response.errors)

$.extend(SessionTabs.signinForm, SessionTabs.tabForm)

SessionTabs.newPasswordForm =
  containerSelector: '#forgot_password_form_container'
  afterSuccess: (event, data, success, xhr) ->
    response = $.parseJSON(xhr.responseText)
    SessionTabs.newPasswordForm.flash(response)
  afterError: (event, xhr, status, error) ->
    error_container = $('#forgot_password_error_message')
    response = $.parseJSON(xhr.responseText)
    for error, message of response
      SessionTabs.Helpers.addValidationError(error, message) 

$.extend(SessionTabs.newPasswordForm, SessionTabs.tabForm)

$(->
  SessionTabs.bindNavigation()
  SessionTabs.bindActions()
)
