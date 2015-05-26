google.load("visualization", "1", {packages:["timeline", "map"]});

// function drawDate(username, date, device){
//     $.ajax({
//         type: 'GET',
//         url: dsu + "dataPoints/"+getDatapointId(username, date, device),
//         headers: {
//             "Authorization": "Bearer " + token
//         },
//         success : function(data) {
//             console.log(data);
//             drawChart(data,device)
//         },
//         error: function(data){
//             console.log("errorrrrrrrr");
//         }

//     });
// }


// function showSummary(username, date, device) {
//     $.ajax({
//         type: 'GET',
//         url: dsu + "dataPoints/" + getSummaryDatapointId(username, date, device),
//         headers: {
//             "Authorization": "Bearer " + token
//         },
//         success: function(data) {
//             console.log(data);
//             $("#walking-distance").html((data.body["walking_distance_in_km"]*0.621371192).toFixed(2) + " miles");
//             $("#walking-time").html(moment.duration(data.body["time_not_at_home_in_seconds"], 'seconds').humanize());
//             $('#gait-speed').html(data.body["max_gait_speed_in_meter_per_second"]);
//             },
//         error: function(data){
//             // $("#walking-distance, #walking-time").html("No data");
//             console.log("errorrrrrrrr");
//         }

//     });
// }

