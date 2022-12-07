import pandas
import datetime
import matplotlib as mp
import numpy as np
from geopy import distance

format = '%Y-%m-%dT%H:%M:%S.%fZ'
# planned routes
planned = pandas.read_csv('cdf_graphs\planned.csv')

planned_1 = [
    [51.44695323318842, 7.267433539214133], 
    [51.44536914440679, 7.262819454636345], 
    [51.44565667849247, 7.262551233725929], 
    [51.44622818537367, 7.26420735142369], 
    [51.44687011677727, 7.266357101961729]]


planned_2 = []
for i in range(3, 13):
    planned_2.append([planned.at[i, 'lat'], planned.at[i, 'long']])

# manual points
walked = pandas.read_csv('cdf_graphs\walked.csv')

walked_11 = []
walked_12 = []
walked_13 = []

walked_21 = []
walked_22 = []
walked_23 = []

for i in range(42):
    if(i<5):
        walked_11.append([walked.at[i, 'timestamp'], walked.at[i, 'lat'], walked.at[i, 'long']])
    if(4<i<10):
        walked_12.append([walked.at[i, 'timestamp'], walked.at[i, 'lat'], walked.at[i, 'long']])
    if(9<i<15):
        walked_13.append([walked.at[i, 'timestamp'], walked.at[i, 'lat'], walked.at[i, 'long']])    
    if(14<i<25):
        walked_21.append([walked.at[i, 'timestamp'], walked.at[i, 'lat'], walked.at[i, 'long']])
    if(24<i<34):
        walked_22.append([walked.at[i, 'timestamp'], walked.at[i, 'lat'], walked.at[i, 'long']])
    if(33<i<43):
        walked_23.append([walked.at[i, 'timestamp'], walked.at[i, 'lat'], walked.at[i, 'long']])

# continuous tracking
tracked = pandas.read_csv('cdf_graphs/tracked.csv')

tracked_11 = []
tracked_12 = []
tracked_13 = []

tracked_21 = []
tracked_22 = []
tracked_23 = []

for i in range(1300):
    if((tracked.at[i, 'timestamp'] >= walked.at[0, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[4, 'timestamp'])):
        tracked_11.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])
    if((tracked.at[i, 'timestamp'] >= walked.at[5, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[9, 'timestamp'])):
        tracked_12.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])
    if((tracked.at[i, 'timestamp'] >= walked.at[10, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[14, 'timestamp'])):
        tracked_13.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])
    if((tracked.at[i, 'timestamp'] >= walked.at[15, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[24, 'timestamp'])):
        tracked_21.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])
    if((tracked.at[i, 'timestamp'] >= walked.at[24, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[33, 'timestamp'])):
        tracked_22.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])
    if((tracked.at[i, 'timestamp'] >= walked.at[33, 'timestamp']) & (tracked.at[i, 'timestamp'] <= walked.at[42, 'timestamp'])):
        tracked_23.append([tracked.at[i, 'lat'], tracked.at[i, 'long']])

# pos from planned, time from walked
def interpolation(posA, posB, t1, t2):
    coordinates = []
    diffLat = posB[0]-posA[0]
    diffLong = posB[1]-posA[1]
    t21 = (datetime.datetime.strptime(t2,format) - datetime.datetime.strptime(t1,format)).total_seconds()*1000
    step = t21/help(t1, t2)
    start = 0
    end = t21
    t = start + step

    while(t<=end):
        diffT = (t-start)/t21
        newLong = posA[1] + (diffLong * diffT)
        newLat = posA[0] + (diffLat * diffT)
        newLoc = [newLat, newLong]
        coordinates.append(newLoc)
        t = t+step
    
    return coordinates

#anzahl an getrackten punkten zwischen zwei walked punkten um festzustellen, wie viele interpoliert werden müssen
def help(timeA, timeB):
    count = 0
    for i in range(1300):
        if((tracked.at[i, 'timestamp'] >= timeA) & (tracked.at[i, 'timestamp'] <= timeB)):
            count = count+1
    return count

def comparison(plan, walk):
    dist = []
    help = 0
    for j in range(len(plan)-1):
        predict = interpolation(plan[j], plan[j+1], walk[j][0], walk[j+1][0])
        for i in range(len(predict)):
            dist.append(distance.distance(predict[i], tracked_11[help]).meters)
            help = help+1
    return dist


# x fehler in meter y % anteil
def plotting():
    sorted = np.sort(comparison(planned_1, walked_11))
    max = np.round_(sorted[len(sorted)-1], decimals = -1)+ 10
    
    
plotting()