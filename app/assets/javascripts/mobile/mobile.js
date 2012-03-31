//= require jquery
//= require jquery_ujs
//= require jquery.mobile
//= require rails.validations
//= require_directory .

// Displays an information dialog containing content in dialog_id
function show_dialog(dialog_id, notice)
{

$(document).delegate('.vote_link', 'click', function() {
  $(dialog_id).simpledialog({
    'mode' : 'bool',
    'prompt' : notice,
    'useModal': true,
    'buttons' : {
      'OK': {
        click: function () {
          $('#dialogoutput').text('OK');
        }
      },
      'Cancel': {
        click: function () {
          $('#dialogoutput').text('Cancel');
        },
        icon: "delete",
        theme: "c"
      }
    }
  })
})

}
