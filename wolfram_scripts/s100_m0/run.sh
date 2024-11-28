echo "Start Time: $(date +%H:%M:%S)"
WolframKernel -script phase1.wls > phase1.log &
WolframKernel -script phase2.wls > phase2.log &
WolframKernel -script phase3.wls > phase3.log &
WolframKernel -script phase4.wls > phase4.log &
wait
WolframKernel -script phase5.wls > phase5.log &
WolframKernel -script phase6.wls > phase6.log &
WolframKernel -script phase7.wls > phase7.log &
WolframKernel -script phase8.wls > phase8.log &
wait
WolframKernel -script phase9.wls > phase9.log &
WolframKernel -script phase10.wls > phase10.log &
WolframKernel -script phase11.wls > phase11.log &
WolframKernel -script phase12.wls > phase12.log &
wait
WolframKernel -script phase13.wls > phase13.log &
WolframKernel -script phase14.wls > phase14.log &
WolframKernel -script phase15.wls > phase15.log &
WolframKernel -script phase16.wls > phase16.log &
wait
WolframKernel -script phase17.wls > phase17.log &
WolframKernel -script phase18.wls > phase18.log &
WolframKernel -script phase19.wls > phase19.log &
WolframKernel -script phase20.wls > phase20.log &
wait
WolframKernel -script phase21.wls > phase21.log &
WolframKernel -script phase22.wls > phase22.log &
WolframKernel -script phase23.wls > phase23.log &
WolframKernel -script phase24.wls > phase24.log &
wait
WolframKernel -script phase25.wls > phase25.log &
WolframKernel -script phase26.wls > phase26.log &
WolframKernel -script phase27.wls > phase27.log &
WolframKernel -script phase28.wls > phase28.log &
wait
WolframKernel -script phase29.wls > phase29.log &
WolframKernel -script phase30.wls > phase30.log &
WolframKernel -script phase31.wls > phase31.log &
WolframKernel -script phase32.wls > phase32.log &
wait
WolframKernel -script phase33.wls > phase33.log &
wait
echo "End Time: $(date +%H:%M:%S)"
