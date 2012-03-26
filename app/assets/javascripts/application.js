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
//= require_tree .
//= require rails.validations
//= require jquery.qtip

function toggle_section(section, text, state1, state2)
{
    $(section).toggle(300, 'linear');
	$(text).text($(text).text() == state1 ? state2 : state1);
	return false;
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

// Add tooltips to link elements
$(document).ready(function()
{
    // Match all elements with class link_tooltip and use data-tooltip to display tooltip text.
    $('.tooltip').qtip({
        content: function(){
            return $(this).data('tooltip');
        },
		style: {
			width: 200,
			border: 0,
			classes: "ui-tooltip-tipsy"
		},
        position: {
            corner: {   target: 'rightMiddle',
                        tooltip: 'leftMiddle'
                    },
            adjust: { x: -5, y: -5 }
        }
    });
});

// Yes/No Confirmation box
$("#yesno").easyconfirm({locale: { title: 'Select Yes or No', button: ['No','Yes']}});
$("#yesno").click(function() {
	alert("You clicked yes");
});