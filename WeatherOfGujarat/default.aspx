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
    <link href="Content/css/dvxCharts.chart.css" rel="stylesheet" />
    <link href="Content/css/styles.css" rel="stylesheet" />
    <script src="Content/js/dvxCharts.chart.min.js"></script>
    <style>
        .example-container {
            width: 100%;
            max-width: 500px;
            height: 300px;
        }

        .mySeries .dvx-chart-series-label {
            font-size: 15px;
            fill: white;
        }
    </style>


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
                    <script>
                        //http://localhost:57410/retriveinformation.asmx
                        var districtJson = [
                            {
                                id: 0,
                                name: 'Ahmedabad',
                                x: 652,
                                y: 790
                            },

                            {
                                id: 14,
                                name: 'Patan',
                                x: 628,
                                y: 597
                            },

                            {
                                id: 10,
                                name: 'Mahesana',
                                x: 664,
                                y: 638
                            }
                        ];
                        $("#ddlDistrict").on("change", function () {
                            var id = this.value;
                            //alert(id);
                            $.ajax({

                                type: "POST",

                                url: "readdata.aspx/GetDataDistrict",

                                contentType: "application/json; charset=utf-8",

                                dataType: "json",

                                data: "{ 'districtId': '" + id + "' }",

                                success: function (response) {

                                    $.each(response, function (index, d) {

                                        console.log(d);
                                        var rain = parseFloat(d[0].Rain);
                                        //alert(rain);
                                        var chart = new dvxCharts.Chart({
                                            title: {
                                                text: d.District_Name
                                            },
                                            legend: {
                                                title: 'Countries'
                                            },
                                            animation: {
                                                duration: 1
                                            },
                                            series: [
                                                {
                                                    type: 'pie',
                                                    class: 'mySeries',
                                                    labels: {
                                                        stringFormat: '%.1f%%',
                                                        valueType: 'percentage'
                                                    },
                                                    explodedRadius: 10,
                                                    explodedSlices: [5],
                                                    data: [["Rain", rain], ['Hot `C', d[0].Temperature1], ['Cool `C', d[0].Temperature2]]
                                                }
                                            ]
                                        });

                                        chart.addEventListener('tooltipFormat', function (e, data) {
                                            var percentage = data.series.getPercentage(data.value);
                                            percentage = data.chart.stringFormat(percentage, '%.2f%%');

                                            e.result = '<b>' + data.dataItem[0] + '</b><br />' +
                                                data.value + ' (' + percentage + ')';
                                        });

                                        $("#container").html("");
                                        chart.write('container');
                                        for (var i = 0; i < districtJson.length; i++) {
                                            if (districtJson[i].id == id) {
                                                $('#marker').css('left', districtJson[i].x - 30).css('top', districtJson[i].y - 380).show();
                                                break;
                                            }

                                        }
                                        

                                    });

                                },

                                failure: function (response) {

                                    //alert(response.d);

                                }

                            });

                        })

                        $("#ddlTaluka").on("change", function () {
                            var id = this.value;
                            //alert(id);
                            $.ajax({

                                type: "POST",

                                url: "readdata.aspx/GetDataTaluka",

                                contentType: "application/json; charset=utf-8",

                                dataType: "json",

                                data: "{ 'talukaId': '" + id + "' }",

                                success: function (response) {

                                    $.each(response, function (index, d) {

                                        console.log(d);
                                        var rain = parseFloat(d[0].Rain);
                                        //alert(rain);
                                        var chart = new dvxCharts.Chart({
                                            title: {
                                                text: d.Taluka_Name
                                            },
                                            legend: {
                                                title: 'Countries'
                                            },
                                            animation: {
                                                duration: 1
                                            },
                                            series: [
                                                {
                                                    type: 'pie',
                                                    class: 'mySeries',
                                                    labels: {
                                                        stringFormat: '%.1f%%',
                                                        valueType: 'percentage'
                                                    },
                                                    explodedRadius: 10,
                                                    explodedSlices: [5],
                                                    data: [["Rain", rain], ['Hot `C', d[0].Temperature1], ['Cool `C', d[0].Temperature2]]
                                                }
                                            ]
                                        });

                                        chart.addEventListener('tooltipFormat', function (e, data) {
                                            var percentage = data.series.getPercentage(data.value);
                                            percentage = data.chart.stringFormat(percentage, '%.2f%%');

                                            e.result = '<b>' + data.dataItem[0] + '</b><br />' +
                                                data.value + ' (' + percentage + ')';
                                        });
                                        $("#container").html("");
                                        chart.write('container');


                                    });

                                },

                                failure: function (response) {

                                    //alert(response.d);

                                }

                            });

                        })
                    </script>

                </div>
            </div>
            <div class="row">
                <div class="col-md-8">
                    <h3>Gujarat District & Taluka</h3>
                    <img src="Content/images/map-marker.svg" id="marker" style="display: none; position: absolute;" />
                    <img src="Content/images/g1.jpg" class="img-fluid" id="map" />

                    <script type="text/javascript">

                        $('#map').click(function (e) {



                            $('#marker').css('left', e.pageX - 30).css('top', e.pageY - 380).show();
                            alert("y: " + e.pageY + ", x: " + e.pageX);
                        });
                    </script>
                </div>
                <div class="col-md-4">
                    <h3>Details</h3>

                    <div id="container" class="example-container">
                    </div>
                    <%--<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>
                    <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris...</p>--%>
                </div>
            </div>
        </div>

    </form>
</body>
</html>
