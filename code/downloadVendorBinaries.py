import urllib2, os, errno, shutil, sys

'''
last-edit-date: 11/12/2015
Version: 1.0
Author: Prajit Kumar Das
Email: prajitdas AT gmail DOT com
Purpose: This program will download all the vendor dependencies as follows for building the Android ROMs
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
Nexus 5 (GSM/LTE)
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4 (KRT16M)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-krt16m-bf9b8548.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-krt16m-0efa9c33.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-krt16m-53cf1896.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4.2 (KOT49H)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-kot49h-a670ed75.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-kot49h-e6165a67.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-kot49h-518133bf.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4.3 (KTU84M)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84m-175c1204.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84m-716c9c42.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84m-06019566.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4.4 (KTU84P)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84p-5a5bf60e.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84p-49419c39.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84p-f159eadf.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 5.0 (LRX21O)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lrx21o-01fad5db.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-lrx21o-c6cf4582.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-lrx21o-e0cd4949.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 5.0.1 (LRX22C)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lrx22c-964d941e.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-lrx22c-95a9d465.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-lrx22c-e1a10593.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 5.1.0 (LMY47I)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lmy47i-4129297c.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-lmy47i-1a387ac9.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-lmy47i-41f93087.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 5.1.1 (LMY48M)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lmy48m-5d6ca8e6.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-lmy48m-0759ba99.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-lmy48m-b7143e92.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 6.0.0 (MRA58K)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-mra58k-bed5b700.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-mra58k-25d00e3d.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-mra58k-ff98ab07.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 6.0.0 (MRA58N)
https://dl.google.com/dl/android/aosp/broadcom-hammerhead-mra58n-1b71cb95.tgz
https://dl.google.com/dl/android/aosp/lge-hammerhead-mra58n-922a9ee4.tgz
https://dl.google.com/dl/android/aosp/qcom-hammerhead-mra58n-630ddcfd.tgz
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
Nexus 4 
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4 (KRT16S)
https://dl.google.com/dl/android/aosp/broadcom-mako-krt16s-f54c9ff9.tgz
https://dl.google.com/dl/android/aosp/lge-mako-krt16s-23ef7d53.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-krt16s-cc4bd932.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4.2 (KOT49H)
https://dl.google.com/dl/android/aosp/broadcom-mako-kot49h-18b58457.tgz
https://dl.google.com/dl/android/aosp/lge-mako-kot49h-f59c98be.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-kot49h-e7a74920.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4.3 (KTU84L)
https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84l-1503ebe1.tgz
https://dl.google.com/dl/android/aosp/lge-mako-ktu84l-5468db8b.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-ktu84l-a3aa0023.tgz
--------------------------------------------------------------------------------------------------------
binaries for Android 4.4.4 (KTU84P)
https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84p-3a6a5a8b.tgz
https://dl.google.com/dl/android/aosp/lge-mako-ktu84p-2e326822.tgz
https://dl.google.com/dl/android/aosp/qcom-mako-ktu84p-c8f35998.tgz
--------------------------------------------------------------------------------------------------------
GLOBAL DIRNAME VARIABLE
The part that we extract as the directory name is in the file name.
For example for broadcom-hammerhead-krt16m-bf9b8548.tgz the directory name is hammerhead-krt16m.
'''
def make_sure_path_exists(path):
	try:
		os.makedirs("../binaries/"+path)
	except OSError as exception:
		if exception.errno != errno.EEXIST:
			raise

def deleteFolders(dirnames):
	for dir in dirnames:
		if os.path.exists("../binaries"):
			shutil.rmtree("../binaries")

def downloadVendorBinaries(dirnames):
	'''
	Put all the vendor binary URLS in the following variable.
	The binaries can be obtained from this link: https://developers.google.com/android/nexus/drivers
	'''
	urllists = [["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-mra58n-1b71cb95.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-mra58n-922a9ee4.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-mra58n-630ddcfd.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-krt16m-bf9b8548.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-krt16m-0efa9c33.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-krt16m-53cf1896.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-kot49h-a670ed75.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-kot49h-e6165a67.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-kot49h-518133bf.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84m-175c1204.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84m-716c9c42.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84m-06019566.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-ktu84p-5a5bf60e.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-ktu84p-49419c39.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-ktu84p-f159eadf.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lrx21o-01fad5db.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-lrx21o-c6cf4582.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-lrx21o-e0cd4949.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lrx22c-964d941e.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-lrx22c-95a9d465.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-lrx22c-e1a10593.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lmy47i-4129297c.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-lmy47i-1a387ac9.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-lmy47i-41f93087.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-lmy48m-5d6ca8e6.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-lmy48m-0759ba99.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-lmy48m-b7143e92.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-hammerhead-mra58k-bed5b700.tgz","https://dl.google.com/dl/android/aosp/lge-hammerhead-mra58k-25d00e3d.tgz","https://dl.google.com/dl/android/aosp/qcom-hammerhead-mra58k-ff98ab07.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-krt16s-f54c9ff9.tgz","https://dl.google.com/dl/android/aosp/lge-mako-krt16s-23ef7d53.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-krt16s-cc4bd932.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-kot49h-18b58457.tgz","https://dl.google.com/dl/android/aosp/lge-mako-kot49h-f59c98be.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-kot49h-e7a74920.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84l-1503ebe1.tgz","https://dl.google.com/dl/android/aosp/lge-mako-ktu84l-5468db8b.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-ktu84l-a3aa0023.tgz"],["https://dl.google.com/dl/android/aosp/broadcom-mako-ktu84p-3a6a5a8b.tgz","https://dl.google.com/dl/android/aosp/lge-mako-ktu84p-2e326822.tgz","https://dl.google.com/dl/android/aosp/qcom-mako-ktu84p-c8f35998.tgz"]]

	listCounter = 0
	for urls in urllists:
		for url in urls:
			binaryFile = urllib2.urlopen(url)
			splitFilename = url.split("aosp/")
			filename= splitFilename[1]
			make_sure_path_exists(dirnames[listCounter])
			output = open("../binaries/"+dirnames[listCounter]+"/"+filename,'w')
			output.write(binaryFile.read())
			output.close()
		listCounter = listCounter + 1

def main(argv):
	if len(sys.argv) != 2:
		sys.stderr.write('Usage: python downloadVendorBinaries.py [dl|clear]\n')
		sys.exit(1)
		
	dirnames = ["hammerhead-krt16m","hammerhead-kot49h","hammerhead-ktu84m","hammerhead-ktu84p","hammerhead-lrx21O","hammerhead-lrx22c","hammerhead-lmy47i","hammerhead-lmy48m","hammerhead-mra58k","hammerhead-mra58n","mako-krt16s","mako-kot49h","mako-ktu84l","mako-ktu84p"]
	if sys.argv[1] == "clear":
		deleteFolders(dirnames)
	elif sys.argv[1] == "dl":
		downloadVendorBinaries(dirnames)

if __name__ == "__main__":
	sys.exit(main(sys.argv))
