'''
last-edit-date: 08/15/2016
Version: 1.1
@author: Prajit Kumar Das
@coAuthor: Abhay Kashyap
Usage: python downloadVendorBinaries.py deviceId(for example hammerhead, bullhead)
Email: prajitdas AT gmail DOT com
Purpose: This program will download all vendor dependencies for building device specific Android ROMs
-----------------------
GLOBAL DIRNAME VARIABLE
The part that we extract as the directory name is in the file name.
For example for broadcom-hammerhead-krt16m-bf9b8548.tgz the directory name is hammerhead-krt16m.
'''

import os
import errno
import sys
import json
from bs4 import BeautifulSoup
import urllib2

def make_sure_path_exists(path):
	if not os.path.exists(path):
		os.makedirs(path)

def downloadVendorBinaries(deviceId):
	'''
	Put all the vendor binary URLS in the following variable.
	'''
	with open('urls.json') as data_file:
		urls = json.load(data_file)
	
	for url in urls['urls']:
		if deviceId in url:
			filename = url.split('aosp/')[1]
			folderName = '../binaries/'+filename.split('-')[1]+'-'+filename.split('-')[2]
			make_sure_path_exists(folderName)

			print 'Downloading url: ' + url
			binaryFile = urllib2.urlopen(url)

			fileLocation = folderName+'/'+filename
			output = open(fileLocation,'w')
			output.write(binaryFile.read())
			output.close()

def extractBinaryUrls(binaryUrl):
	headers = { 'User-Agent' : 'Mozilla/5.0' }
	req = urllib2.Request(binaryUrl, None, headers)
	try:
		page = urllib2.urlopen(req).read()
		soup = BeautifulSoup(page,'lxml')
		urls = {'urls':[]}
		for anchor in soup.findAll('a'):
			# print anchor
			if 'https://dl.google.com/dl/android/aosp' in anchor['href']:
				urls['urls'].append(anchor['href'])
		open('urls.json','w').write(json.dumps(urls, indent=4))
	except:
		pass	

def main(argv):
	if len(sys.argv) != 2:
		sys.stderr.write('Usage: python downloadVendorBinaries.py deviceId\n')
		sys.exit(1)
		
	deviceId = sys.argv[1]
	
	'''
	The binaries can be obtained from this link: https://developers.google.com/android/nexus/drivers
	'''
	extractBinaryUrls('https://developers.google.com/android/nexus/drivers')
	
	downloadVendorBinaries(deviceId)

if __name__ == '__main__':
	sys.exit(main(sys.argv))
