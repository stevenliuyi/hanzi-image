SetDirectory@NotebookDirectory[];

chars = StringCases["朝辭白帝彩雲間", _];
fonts = "Source Han Sans SC " <> # & /@ {"ExtraLight", "Light", 
    "Normal", "Regular", "Medium", "Bold", "Heavy"};

charDensityList = 
    Partition[
        Mean /@ Flatten /@ ImageData /@ Rasterize /@ 
            Flatten@Outer[
                Style[#, FontSize -> 12, FontFamily -> #2] &, 
            chars, fonts],
        Length[fonts]] // Rescale;

indices = 
    Map[First@ Position[Abs[charDensityList - #], 
            Min[Abs[charDensityList - #]]] &, 
        Import["Lenna.jpg"]~ImageResize~100~ColorConvert~"Grayscale" // 
            ImageData // Rescale,
        {2}];

Export["Lenna_export.png",
    {ImageCrop[#, {1200, 12}] & /@ 
        Rasterize /@ (Row[#, ImageSize -> 1201] & /@ 
            Map[Style[chars[[#[[1]]]], FontSize -> 12, 
                FontFamily -> fonts[[#[[2]]]]] &, indices, {2}])}
    // Transpose // ImageAssemble];
