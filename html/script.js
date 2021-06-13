//  Luara ;#2547 | Yuval#6296 | https://discord.gg/3sqYyVjJ5J

var users;
var run = false;

window.addEventListener('message', function(event) {
    var data = event.data

    switch (data.type) {
        case 'refresh':
            run = true
            refreshAll(data);
            break;
        case 'settingsclose':
            settingsclose();
            break;
        case 'mainclose':
            run = false
            mainclose();
            break;
        case 'settings':
            settings();
            break;
        case 'forceclose':
            mainclose();
            settingsclose();
            break;
    }

    document.onkeyup = function (data) {
        if (data.which == 27 ) {
            $.post('https://ys-activity/settingsclose');
            settingsclose()
        }
    }
})


$('.success').click(function() {
    if ($(".user-data").val() !== "")  {
        setTimeout(function() {
            $.post('https://ys-activity/callsign', JSON.stringify({
                callsign: $(".user-data").val()
            }));
        }, 500)
    }
});


$('.toggle').click(function() {
    setTimeout(function() {
        $.post('https://ys-activity/toggle', JSON.stringify({
            toggle: run
        }));
    }, 300)
});

function refreshAll(data) {
    users = data.users
    $(".officers-list-container").empty()
    for (const [key, value] of Object.entries(users)) {
        addPlayers(value)
    }
    $(".activity-container").fadeIn();

}

function settings() {
    $(".settings").fadeIn();
}

function settingsclose() {
    $(".settings").fadeOut();
}
function mainclose() {
    $(".activity-container").fadeOut();
}

function addPlayers(value) {
    if (value.count !== 0) {
        $(".container-header").empty()
        $('.container-header').append(`<p class="title">Active Officers (${value.count})</p>`)
        $('.officers-list-container').append(`
        <div class="officer-card">
            <div class="duty-on"><i class="fas fa-check-circle"></i></div>
            <div class="name">${value.name}</div>
            <div class="grade">(${value.grade})</div>
            <div class="callsign"><i class="fas fa-hashtag"></i> ${value.callsign}</div>
        </div>
        `)
    } else {
        $(".container-header").empty()
        $('.container-header').append(`<p class="title">Active Officers (0)</p>`)
        $('.officers-list-container').append(`
        <div class="officer-card">
        <p class="name"><i class="fas fa-address-card"></i> No data received</p>
        </div>
        `)
    }
}
