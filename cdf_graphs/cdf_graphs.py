import pandas

# planned routes
planned = pandas.read_csv('cdf_graphs\planned.csv')

planned_1 = [
    [51.44695323318842, 7.267433539214133], 
    [51.44536914440679, 7.262819454636345], 
    [51.44565667849247, 7.262551233725929], 
    [51.44622818537367, 7.26420735142369], 
    [51.44687011677727, 7.266357101961729]]
for i in range(3):
    planned_1.append([planned.at[i, 'lat'], planned.at[i, 'long']])


planned_2 = []
for i in range(3, 13):
    planned_2.append([planned.at[i, 'lat'], planned.at[i, 'long']])

# continuous tracking
tracked = pandas.read_csv('cdf_graphs/tracked.csv')

# manual points
walked = pandas.read_csv('cdf_graphs\walked.csv')

walked_11 = []
for i in range(6):
    walked_11.append([walked.at[i, 'lat'], walked.at[i, 'long']])

walked_12 = []
for i in range(6, 10):
    walked_12.append([walked.at[i, 'lat'], walked.at[i, 'long']])

walked_13 = []
for i in range(10, 15):
    walked_13.append([walked.at[i, 'lat'], walked.at[i, 'long']])


walked_21 = []
for i in range(15, 26):
    walked_21.append([walked.at[i, 'lat'], walked.at[i, 'long']])

walked_22 = []
for i in range(26, 34):
    walked_22.append([walked.at[i, 'lat'], walked.at[i, 'long']])

walked_23 = []
for i in range(34, 43):
    walked_23.append([walked.at[i, 'lat'], walked.at[i, 'long']])

tracked_11 = []
for i in range(1301):
    while(tracked.at[i, 'timestamp'] == 1):
        #help
        tracked_11.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])
tracked_12 = []
for i in range(1301):
    if((tracked.at[i, 'timestamp'] >= walked.at[6, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[9, 'timestamp'])):
        tracked_12.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])

tracked_13 = []
for i in range(1301):
    if((tracked.at[i, 'timestamp'] >= walked.at[10, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[14, 'timestamp'])):
        tracked_13.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])

tracked_21 = []
for i in range(1301):
    if((tracked.at[i, 'timestamp'] >= walked.at[15, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[25, 'timestamp'])):
        tracked_21.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])

tracked_22 = []
for i in range(1301):
    if((tracked.at[i, 'timestamp'] >= walked.at[26, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[33, 'timestamp'])):
        tracked_22.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])

tracked_23 = []
for i in range(1301):
    if((tracked.at[i, 'timestamp'] >= walked.at[34, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[42, 'timestamp'])):
        tracked_12.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])

print(tracked_13[0][0])

def interpolation(posA, posB, t1, t2):
    coordinates = []
    diffLat = posB[0]-posA[0]
    diffLong = posB[1]-posA[1]