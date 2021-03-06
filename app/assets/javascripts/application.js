// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require rails.validations
//= require jquery_nested_form
//= require autocomplete-rails
//= require jquery.facebox
//= require_directory ./plugins
//= require_directory .

// Load nicEdit
bkLib.onDomLoaded(function() {
	var customNicEditor = new nicEditor({buttonList : [
		'bold','italic','underline','ul','ol','strikeThrough','html','fontSize','image','upload',
		'link','unlink','removeformat','indent','outdent','hr','left','center','right','justify'
	]}).panelInstance('rich_textarea');
});

// Load indextank autocomplete
$(document).ready(function(){
    // let the form be 'indextank-aware'
    $("#search_form").indextank_Ize('http://ya1a.api.searchify.com', 'idx');
    // let the query box have autocomplete
    $("#search_input").indextank_Autocomplete();
});

// Function to toggle visibility of a section using a link
function toggle_section(section, link, state1, state2)
{
    $(section).toggle(300, 'linear');
$(link).text($(link).text() == state1 ? state2 : state1);
return false;
}

// Displays a dialog box containing the information in dialog_id upon pressing submit_id
function confirm_submit(dialog_id, submit_id)
{
  // Form submit confirmation
  var currentForm;
  $(document).ready(function() {
        $(dialog_id).dialog({
            resizable: false,
            height: 160,
            modal: true,
            autoOpen: false,
            buttons: {
                'Yes': function() {
                    $(this).dialog('close');
                    currentForm.submit();
                },
                'No': function() {
                    $(this).dialog('close');
                }
            }
        });
        
        $(submit_id).click(function() {
          currentForm = $(this).closest('form');
          $(dialog_id).dialog('open');
          return false;
        });
    
  });
}

// Displays an information dialog containing content in dialog_id
function show_dialog(dialog_id)
{
    $(dialog_id).dialog({
            resizable: false,
            height: 160,
            modal: true,
            buttons: {
                'OK': function() {
                    $(this).dialog('close');
                }
            }
    });
}


// Code to implement the search clear button
$(document).ready(function() {
    // if text input field value is not empty show the "X" button
    $("#search_input").keyup(function() {
        $("#x").fadeIn();
        if ($.trim($("#search_input").val()) == "") {
            $("#x").fadeOut();
        }
    });
    // on click of "X", delete input field value and hide "X"
    $("#x").click(function() {
        $("#search_input").val("");
        $(this).hide();
    });
});

// Add tooltips to link elements using the qtip plugin
$(document).ready(function()
{
    // Match all elements with class tooltip and use data-tooltip to display tooltip text.
    $('.tooltip').qtip({
        content: function(){
            return $(this).data('tooltip');
        },
style: {
width: 290,
border: 0,
classes: "ui-tooltip-tipsy"
},
        position: {
            corner: { target: 'rightMiddle',
                        tooltip: 'leftMiddle'
                    },
            adjust: { x: -5, y: -5 }
        }
    });
});


$(document).ready(function()
{
	$(function() {
		// Hide button to remove first field of nested attributes
		$('.fields .error_remove:first').css('display', 'none');
		$('.fields .category_remove:first').css('display', 'none');
		$('.fields .tag_remove:first').css('display', 'none');
		// Apply jQuery UI styling to buttons
		$( "a.add_nested_fields", ".new" ).button();
		$( "input:submit", ".form-buttons" ).button();
		$( "input:submit", ".comment_form" ).button();
		// Add Modal box to login link
		$('a.login').facebox({  
        	loadingImage : '/images/ajax-loader.gif',
    		closeImage   : '/images/closelabel.gif',  
    	});
    	$(document).bind('reveal.facebox', function() {
    		$( "input:submit", ".form-buttons" ).button();
	        $('.login form').submit(function() {
	            $.post(this.action, $(this).serialize(), null, "script");
	            return false;
	        });  
    	}); 
	});
});