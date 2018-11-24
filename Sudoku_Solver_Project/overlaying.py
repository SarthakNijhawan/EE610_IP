import cv2
import matplotlib.pyplot as plt

#Initiate the two cameras
cap = cv2.VideoCapture(0)

cap.set(3,320)
cap.set(4,240)
# cap.set(cv2.cv.CV_CAP_PROP_FPS, 60)

#create two subplots
ax1 = plt.subplot(1,2,1)
ax2 = plt.subplot(1,2,2)


#create two image plots
ret,frame = cap.read()
im1 = ax1.imshow(frame)
im2 = ax2.imshow(frame)

plt.ion()

while True:
	ret,frame = cap.read()
	im1.set_data(cv2.cvtColor(frame,cv2.COLOR_BGR2RGB))

	frame = cv2.flip(frame,0)
	im2.set_data(cv2.cvtColor(frame,cv2.COLOR_BGR2RGB))
	
	if cv2.waitKey(1) & 0xFF == ord('q'):
		break

plt.ioff() # due to infinite loop, this gets never called.
plt.show()