__author__ = 'abhishek'

pollutants = ["PM25_Concentration", "PM10_Concentration", "NO2_Concentration", "CO_Concentration", "O3_Concentration",
               "SO2_Concentration"]

aqi_index = {}

C_LOW = "c_low"
C_HIGH = "c_high"
I_LOW = "i_low"
I_HIGH = "i_high"

def init_aqi_index():
    for pollutant in pollutants:
        if pollutant == "PM25_Concentration":
            range_list = []
            range_list.append(create_range_dict(0.0, 12.0, 0, 50))
            range_list.append(create_range_dict(12.1, 35.4, 51, 100))
            range_list.append(create_range_dict(35.5, 55.4, 101, 150))
            range_list.append(create_range_dict(55.5, 150.4, 151, 200))
            range_list.append(create_range_dict(150.5, 250.4, 201, 300))
            range_list.append(create_range_dict(250.5, 350.4, 301, 400))
            range_list.append(create_range_dict(350.5, 500.4, 401, 500))
            aqi_index[pollutant] = range_list

        elif pollutant == "PM10_Concentration":
            range_list = []
            range_list.append(create_range_dict(0.0, 54.0, 0, 50))
            range_list.append(create_range_dict(55.0, 154.0, 51, 100))
            range_list.append(create_range_dict(155.0, 254.0, 101, 150))
            range_list.append(create_range_dict(255.0, 354.0, 151, 200))
            range_list.append(create_range_dict(355.0, 424.0, 201, 300))
            range_list.append(create_range_dict(425.0, 504.0, 301, 400))
            range_list.append(create_range_dict(505.0, 604.0, 401, 500))
            aqi_index[pollutant] = range_list

        elif pollutant == "NO2_Concentration":
            range_list = []
            range_list.append(create_range_dict(0.0, 53.0, 0, 50))
            range_list.append(create_range_dict(54.0, 100.0, 51, 100))
            range_list.append(create_range_dict(101.0, 360.0, 101, 150))
            range_list.append(create_range_dict(361.0, 649.0, 151, 200))
            range_list.append(create_range_dict(650.0, 1249.0, 201, 300))
            range_list.append(create_range_dict(1250.0, 1649.0, 301, 400))
            range_list.append(create_range_dict(1650.0, 2049.0, 401, 500))
            aqi_index[pollutant] = range_list

        elif pollutant == "CO_Concentration":
            range_list = []
            range_list.append(create_range_dict(0.0, 4.4, 0, 50))
            range_list.append(create_range_dict(4.5, 9.4, 51, 100))
            range_list.append(create_range_dict(9.5, 12.4, 101, 150))
            range_list.append(create_range_dict(12.5, 15.4, 151, 200))
            range_list.append(create_range_dict(15.5, 30.4, 201, 300))
            range_list.append(create_range_dict(30.5, 40.4, 301, 400))
            range_list.append(create_range_dict(40.5, 50.4, 401, 500))
            aqi_index[pollutant] = range_list

        elif pollutant == "O3_Concentration":
            range_list = []
            range_list.append(create_range_dict(0.0, 60.0, 0, 50))
            range_list.append(create_range_dict(60.0, 124.0, 51, 100))
            range_list.append(create_range_dict(125.0, 164.0, 101, 150))
            range_list.append(create_range_dict(165.0, 204.0, 151, 200))
            range_list.append(create_range_dict(205.0, 404.0, 201, 300))
            range_list.append(create_range_dict(405.0, 504.0, 301, 400))
            range_list.append(create_range_dict(505, 604.0, 401, 500))
            aqi_index[pollutant] = range_list

        elif pollutant == "SO2_Concentration":
            range_list = []
            range_list.append(create_range_dict(0.0, 35.0, 0, 50))
            range_list.append(create_range_dict(36.0, 75.0, 51, 100))
            range_list.append(create_range_dict(76.0, 185.0, 101, 150))
            range_list.append(create_range_dict(186.0, 304.0, 151, 200))
            range_list.append(create_range_dict(305.0, 604.0, 201, 300))
            range_list.append(create_range_dict(605.0, 804.0, 301, 400))
            range_list.append(create_range_dict(805, 1004.0, 401, 500))
            aqi_index[pollutant] = range_list


def create_range_dict(c_low, c_high, i_low, i_high):
    range_item = {}
    range_item[C_LOW] = c_low
    range_item[C_HIGH] = c_high
    range_item[I_LOW] = i_low
    range_item[I_HIGH] = i_high
    return range_item

def get_aqi_value(C, pollutant):
    if pollutant in pollutants:
        range_list = aqi_index[pollutant]
        for item in range_list:
            if C >= item[C_LOW] and C <= item[C_HIGH]:
                return (((item[I_HIGH] - item[I_LOW])/(item[C_HIGH] - item[C_LOW])) * (C - item[C_LOW])) + item[I_LOW]
