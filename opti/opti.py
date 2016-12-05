import sys
import cv2
import numpy as np

frame1 = cv2.imread(str(sys.argv[1]))
frame2 = cv2.imread(str(sys.argv[2]))
prvs = cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)
next = cv2.cvtColor(frame2,cv2.COLOR_BGR2GRAY)
hsv = np.zeros_like(frame1)
hsv[...,1] = 255

#while(1):
next = cv2.cvtColor(frame2,cv2.COLOR_BGR2GRAY)
flow = cv2.calcOpticalFlowFarneback(prvs, next, 0.5, 3, 15, 3, 5, 1.2, 0)
mag, ang = cv2.cartToPolar(flow[...,0], flow[...,1])
hsv[...,0] = ang*180/np.pi/2
hsv[...,2] = cv2.normalize(mag,None,0,255,cv2.NORM_MINMAX)
rgb = cv2.cvtColor(hsv,cv2.COLOR_HSV2BGR)

#cv2.imshow('frame2',rgb)
#k = cv2.waitKey(30) & 0xff

cv2.imwrite(str(sys.argv[3]),rgb)
#cap.release()
cv2.destroyAllWindows()

