import urllib2, os, errno, shutil, sys

'''
last-edit-date: 09/24/2014
Version: 1.0
Author: Prajit Kumar Das
Email: prajitdas AT gmail DOT com
Purpose: This program will download all the vendor dependencies as follows for building the Android ROMs
--------------------------------------------------------------------------------------------------------
Nexus 5 (GSM/LTE) binaries for Android 4.4 (KRT16M)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-krt16m-bf9b8548.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-krt16m-0efa9c33.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-krt16m-53cf1896.tgz
--------------------------------------------------------------------------------------------------------
Nexus 5 (GSM/LTE) binaries for Android 4.4.2 (KOT49H)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-kot49h-a670ed75.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-kot49h-e6165a67.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-kot49h-518133bf.tgz
--------------------------------------------------------------------------------------------------------
Nexus 5 (GSM/LTE) binaries for Android 4.4.3 (KTU84M)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84m-175c1204.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84m-716c9c42.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84m-06019566.tgz
--------------------------------------------------------------------------------------------------------
Nexus 5 (GSM/LTE) binaries for Android 4.4.4 (KTU84P)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84p-5a5bf60e.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84p-49419c39.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84p-f159eadf.tgz
--------------------------------------------------------------------------------------------------------
Nexus 4 binaries for Android 4.4 (KRT16S)
https://dl.google.com/dl/android/aosp/broadcom-mako-krt16s-f54c9ff9.tgz
https://dl.google.com/dl/android/aosp/lge-mako-krt16s-23ef7d53.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-krt16s-cc4bd932.tgz
--------------------------------------------------------------------------------------------------------
Nexus 4 binaries for Android 4.4.2 (KOT49H)
https://dl.google.com/dl/android/aosp/broadcom-mako-kot49h-18b58457.tgz
https://dl.google.com/dl/android/aosp/lge-mako-kot49h-f59c98be.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-kot49h-e7a74920.tgz
--------------------------------------------------------------------------------------------------------
Nexus 4 binaries for Android 4.4.3 (KTU84L)
https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84l-1503ebe1.tgz
https://dl.google.com/dl/android/aosp/lge-mako-ktu84l-5468db8b.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-ktu84l-a3aa0023.tgz
--------------------------------------------------------------------------------------------------------
Nexus 4 binaries for Android 4.4.4 (KTU84P)
https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84p-3a6a5a8b.tgz
https://dl.google.com/dl/android/aosp/lge-mako-ktu84p-2e326822.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-ktu84p-c8f35998.tgz
--------------------------------------------------------------------------------------------------------
'''

'''
GLOBAL DIRNAME VARIABLE
The part that we extract as the directory name is in the file name.
For example for broadcom-hammerhead-krt16m-bf9b8548.tgz the directory name is hammerhead-krt16m.
'''
dirnames = ["hammerhead-krt16m","hammerhead-kot49h","hammerhead-ktu84m","hammerhead-ktu84p","mako-krt16s","mako-kot49h","mako-ktu84l","mako-ktu84p"]

def make_sure_path_exists(path):
	try:
		os.makedirs("binaries/"+path)
	except OSError as exception:
		if exception.errno != errno.EEXIST:
			raise

def deleteFolders():
	for dir in dirnames:
		if os.path.exists("binaries"):
			shutil.rmtree("binaries")

def downloadVendorBinaries():
	'''
	Put all the vendor binary URLS in the following variable.
	The binaries can be obtained from this link: https://developers.google.com/android/nexus/drivers
	'''
	urllists = [["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-krt16m-bf9b8548.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-krt16m-0efa9c33.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-krt16m-53cf1896.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-kot49h-a670ed75.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-kot49h-e6165a67.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-kot49h-518133bf.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84m-175c1204.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84m-716c9c42.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84m-06019566.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84p-5a5bf60e.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84p-49419c39.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84p-f159eadf.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-krt16s-f54c9ff9.tgz","https://dl.google.com/dl/android/aosp/lge-mako-krt16s-23ef7d53.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-krt16s-cc4bd932.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-kot49h-18b58457.tgz","https://dl.google.com/dl/android/aosp/lge-mako-kot49h-f59c98be.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-kot49h-e7a74920.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84l-1503ebe1.tgz","https://dl.google.com/dl/android/aosp/lge-mako-ktu84l-5468db8b.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-ktu84l-a3aa0023.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84p-3a6a5a8b.tgz","https://dl.google.com/dl/android/aosp/lge-mako-ktu84p-2e326822.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-ktu84p-c8f35998.tgz"]]

	listCounter = 0
	for urls in urllists:
		for url in urls:
			binaryFile = urllib2.urlopen(url)
			splitFilename = url.split("aosp/")
			filename= splitFilename[1]
			make_sure_path_exists(dirnames[listCounter])
			output = open("binaries/"+dirnames[listCounter]+"/"+filename,'w')
			output.write(binaryFile.read())
			output.close()
		listCounter = listCounter + 1

def main(argv):
	if len(sys.argv) < 2:
		sys.stderr.write('Usage: sys.argv[0]')
		sys.exit(1)
		
	if sys.argv[1] == "clear":
		deleteFolders()
	elif sys.argv[1] == "dl":
		downloadVendorBinaries()

if __name__ == "__main__":
	sys.exit(main(sys.argv))