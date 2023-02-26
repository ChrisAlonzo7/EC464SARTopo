import datetime

def parse_gps_data(filename):
    points = []
    with open(filename, 'r') as f:
        for line in f:
            data = line.strip().split(',')
            if len(data) >= 3:
                lat, lon, timestamp = data[:3]
                lat = float(lat)
                lon = float(lon)
                timestamp = datetime.datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S')
                # Format the timestamp string to match the SARTopo GPX format
                timestamp_str = timestamp.strftime('%Y-%m-%dT%H:%M:%SZ')
                points.append((lat, lon, timestamp_str))
    return points

def create_gpx_file(filename, points):
    with open(filename, 'w') as f:
        f.write('<?xml version="1.0" encoding="utf-8" standalone="yes"?>\n')
        f.write('<gpx xmlns="http://www.topografix.com/GPX/1/1" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3" creator="Chris" version="1.1">\n')
        f.write('<trk>\n')
        f.write('<name>gps_data_test</name>\n')
        f.write('<trkseg>\n')
        for point in points:
            f.write('<trkpt lat="{0}" lon="{1}">\n'.format(point[0], point[1]))
            f.write('<time>{0}</time>\n'.format(point[2]))
            f.write('</trkpt>\n')
        f.write('</trkseg>\n')
        f.write('</trk>\n')
        f.write('</gpx>\n')

# Example usage
gps_data_filename = 'Stuvi_to_Photonics.txt'
points = parse_gps_data(gps_data_filename)
create_gpx_file('Stuvi_to_Photonics2.gpx', points)
