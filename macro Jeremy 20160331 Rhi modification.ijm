run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
dir = getDirectory("image");
filename=getInfo("image.filename")
print("Running analysis on "+filename);
print("Results will be placed in "+ dir);

run("Duplicate...", " ");


sigma = 1.0;
minsize = 1;
maxsize = 10000;



// Create the "difference of gaussians image
run("Duplicate...", "title=scale1");
run("Duplicate...", "title=scale2");
selectWindow("scale1");
run("Gaussian Blur...", "sigma="+sigma);
selectWindow("scale2");
run("Gaussian Blur...", "sigma="+1.6*sigma);
imageCalculator("Subtract create 32-bit", "scale1","scale2");
setAutoThreshold("Intermodes dark");
run("Convert to Mask");


run("Set Measurements...", "area mean centroid center perimeter fit shape median area_fraction redirect=None decimal=3");
run("Analyze Particles...", "size="+minsize+"-"+maxsize+" circularity=0 show=Ellipses display exclude clear add");


again = getBoolean("Change settings??");

while(again){
    close("scale1");
    close("scale2");
    close("Result of scale1");
    close("Drawing of Result of scale1");
    Dialog.create("Change parameters");
    Dialog.addMessage("Change settings");
    Dialog.addSlider("Object size (sigma for filter)", 0.1, 100, sigma);
    Dialog.addSlider("Min Object size (for analyze particles)", 0, 100000, minsize);
    Dialog.addSlider("Object size", 0, 100000, maxsize);
    Dialog.show();
    sigma = Dialog.getNumber();
    minsize = Dialog.getNumber();
    maxsize = Dialog.getNumber();
    // Create the "difference of gaussians image
    run("Duplicate...", "title=scale1");
    run("Duplicate...", "title=scale2");
    selectWindow("scale1");
    run("Gaussian Blur...", "sigma="+sigma);
    selectWindow("scale2");
    run("Gaussian Blur...", "sigma="+1.6*sigma);
    imageCalculator("Subtract create 32-bit", "scale1","scale2");
    setAutoThreshold("Intermodes dark");
    run("Convert to Mask");
    run("Set Measurements...", "area mean centroid center perimeter fit shape median area_fraction redirect=None decimal=3");
    run("Analyze Particles...", "size="+minsize+"-"+maxsize+" circularity=0 show=Ellipses display exclude clear add");
    again = getBoolean("Run again?");
}



dotIndex = lengthOf(filename) - 4;
outname = substring(filename, 0, dotIndex);
saveAs("Results",  dir + outname + ".csv"); 
