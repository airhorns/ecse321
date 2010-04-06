// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var AJAX_SPINNER = '<img src="/images/spinner.gif" alt="Loading...">';

document.observe("dom:loaded",
function() {
    // initially hide all containers for tab content
    var contact_dropdown = $('contact_business_id');
    if (contact_dropdown) {
        contact_dropdown.observe('change',
        function() {
            new Ajax.Updater('business_details', '/businesses/' + $F(contact_dropdown), {
                method: "get",
                onCreate: function() {
                    $('business_details').update(AJAX_SPINNER);
                }
            });
        })
    }
});