<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WeatherOfGujarat._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>

    <%--Chart Plugin--%>
    <script src="Content/js/Chart.min.js"></script>
    <script src="Content/js/utils.js"></script>


    <%--Chart Plugin End--%>
</head>
<body>
    <form id="form1" runat="server">

        <div class="jumbotron text-center">
            <h1>Weather of Gujarat</h1>
            <p></p>
        </div>

        <div class="container-fluid">
            <div class="row">
                <div class="col-md-8 col-md-offset-4">
                    <table class="table table-responsive">

                        <tr>
                            <th>District</th>
                            <th>Taluka</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList ID="ddlDistrict" ClientIDMode="Static" CssClass="form-control" runat="server"></asp:DropDownList>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlTaluka" CssClass="form-control" runat="server"></asp:DropDownList>
                            </td>

                        </tr>
                    </table>


                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <h3>Gujarat District & Taluka</h3>
                    <img src="Content/images/g1.jpg" style="position: absolute; width: 100%" id="marker" class="img-fluid" />
                    <img src="Content/images/g1.jpg" class="img-fluid" style="position: absolute; z-index: -1000; width: 100%" />


                </div>
                <div class="col-md-6">
                    <h3>Details</h3>
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link active" data-toggle="tab" href="#home" onclick="changeChart(1)">Today's</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="tab" href="#menu1" onclick="changeChart(2)">Last 1 Week</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="tab" href="#menu2"  onclick="changeChart(3)">Last 2 Week</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="tab" href="#menu2"  onclick="changeChart(4)">Last 3 Week</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="tab" href="#menu2"  onclick="changeChart(5)">Last Month</a>
                        </li>
                    </ul>
                    <div>
                        <canvas id="canvas"></canvas>
                    </div>
                    <%--<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>
                    <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>--%>
                </div>
            </div>
        </div>

    </form>
    <script>
        var tid = -1;
        var data = [];
        $("#ddlDistrict").on("change", function () {
            var id = this.value;
            //alert(id);
            $.ajax({

                type: "POST",

                url: "readdata.aspx/GetTaluka",

                contentType: "application/json; charset=utf-8",

                dataType: "json",

                data: "{ 'districtId': '" + id + "' }",

                success: function (response) {

                    $.each(response, function (index, d) {

                        console.log(d);
                        var htmlTalukas = "<option>Select Taluka</option>";
                        $.each(d, function (i, v) {
                            htmlTalukas += `<option value='${v.id}'>${v.Taluka_Name}</option>`;
                        });
                        $("#ddlTaluka").html(htmlTalukas);
                        //alert(rain);
                    });



                },

                failure: function (response) {

                    //alert(response.d);

                }

            });

        })

        $("#ddlTaluka").on("change", function () {
            var id = this.value;
            tid = this.value;
            $.ajax({

                type: "POST",

                url: "readdata.aspx/GetDataTalukas",

                contentType: "application/json; charset=utf-8",

                dataType: "json",

                data: "{ 'Id': '" + id + "' }",

                success: function (response) {
                    console.log(response.d);
                    var arr = [];
                    $.each(response.d, function (index, d) {

                        //console.log(d);
                        data.push(d);
                        
                        $("#marker").attr('src', `Content/images/t${id}.png`);

                    });

                    changeChart(1);
                    

                },

                failure: function (response) {

                    //alert(response.d);

                }

            });

        })
        function changeChart(type) {
            if (type == 1) {
                console.log("single data: " + data[data.length - 1]);
                loadChart([data[data.length - 1]]);
            }
            
            else if (type == 2) {
                console.log("single data: " + data[data.length - 1]);
                var arr = [];
                for (var i = data.length - 1; i >= data.length - 7; i--) {
                    arr.push(data[i]);
                }
                loadChart(arr);
            }
            
            else if (type == 3) {
                console.log("single data: " + data[data.length - 1]);
                var arr = [];
                for (var i = data.length - 1; i >= data.length - 14; i--) {
                    arr.push(data[i]);
                }
                loadChart(arr);
            }
            
            else if (type == 4) {
                console.log("single data: " + data[data.length - 1]);
                var arr = [];
                for (var i = data.length - 1; i >= data.length - 21; i--) {
                    arr.push(data[i]);
                }
                loadChart(arr);
            }
            
            else if (type == 4) {
                console.log("single data: " + data[data.length - 1]);
                loadChart(data);
            }
        }
        function loadChart(data) {
            //console.log(data);
            if (data.length == 1) {
                //pie
                var config = {
                    type: 'pie',
                    data: {
                        datasets: [{
                            data: [
                                data[0].Rain, data[0].Temperature1, data[0].Temperature2
                            ],
                            backgroundColor: [
                                window.chartColors.red,
                                window.chartColors.orange,
                                window.chartColors.yellow,
                                window.chartColors.green,
                                window.chartColors.blue,
                            ],
                            label: 'Dataset 1'
                        }],
                        labels: [
                            'Rain',
                            'Max',
                            'Min',
                            'Green',
                            'Blue'
                        ]
                    },
                    options: {
                        responsive: true
                    }
                };
                var ctx = document.getElementById('canvas').getContext('2d');
                window.myPie = new Chart(ctx, config);

            }
            else{
                //line
                var lbls = [];
                var dt1 = [];;
                var dt2 = [];;
                var dt3 = [];
                $.each(data, function (i, v) {
                    lbls.push(v.Created_Date);

                    dt1.push(v.Rain * 10);
                    dt2.push(v.Temperature1);
                    dt3.push(v.Temperature2);

                });
                console.log(dt1);
                var config = {
                    type: 'bar',
                    data: {
                        labels: lbls,
                        datasets: [{
                            label: 'Rain',
                            backgroundColor: window.chartColors.grey,
                            borderColor: window.chartColors.grey,
                            fill: false,
                            data: dt1,
                        }, {
                            label: 'Max',
                            backgroundColor: window.chartColors.yellow,
                            borderColor: window.chartColors.yellow,
                            fill: false,
                            data: dt2,
                        }, {
                            label: 'Min',
                            backgroundColor: window.chartColors.blue,
                            borderColor: window.chartColors.blue,
                            fill: false,
                            data: dt3,
                        }]
                    },
                    options: {
                        responsive: true,
                        title: {
                            display: true,
                            text: 'Chart.js Line Chart - Logarithmic'
                        },
                        scales: {
                            xAxes: [{
                                display: true,
                            }],
                            yAxes: [{
                                display: true,
                                type: 'logarithmic',
                            }]
                        }
                    }
                };
                var ctx = document.getElementById('canvas').getContext('2d');
                window.myLine = new Chart(ctx, config);

            }



        }
    </script>

</body>
</html>
