Interactive Visualization to Explore Set-Typed Data
===================================================

The [original paper by Freiler et al.](http://www.cg.tuwien.ac.at/research/publications/2008/Freiler-2008-Set/Freiler-2008-Set-paper.pdf) implemented an interactive visualization tool to analyze set-typed data. Set-typed data is a non-standard data type for visualization, and there are very few methods that visualize many different sets effectively. The authors created the set'o'gram, a type of bar graph that encodes the overlapping frequency of the data items across multiple sets. The focus was to highlight the interactive techniques used in addition to showing that the tool can scale to higher dimensions (aka more sets).

![set'o'gram interactive visualization](/images/overview.png)

This particular paper:

-  discusses details of set-typed data (good overview of the field)
-  clarifies existing methods for visualizing sets
-  highlights weaknesses of those existing methods
-  encodes a new type of visualization (set'o'gram) that is both innovative and attempts to address those aforementioned weaknesses
-  addresses a problem encountered in my own research
-  effectiveness not clearly measured (much easier to test if already implemented)
-  there is room for improvement in how to encode the set'o'grams (simplifying it)
-  this type of data is fascinatingly interesting


Implementation
--------------

The focus of this work is to re-implement the set'o'gram view from the original paper. Each set is represented by a bar that is broken up into different blocks that vary in width. Each block (going up the bar) represents the amount of data points / items in that set that exist in other sets. The first block represents all items in that set and only in that set. The second block (slightly less wide) represents items in that set that exist in only one other set, and so on. This notion of bars (as sets) and blocks is important, as the blocks encode the overlap frequency of the sets.

![blocks inside of a set'o'gram](/images/blocks.png)

Also, my implementation is created as an interactive legend, meant to accompany a separate spatial view for each data point. This means that interacting with the sets and their blocks within those sets will change the additional linked view that cannot be seen in the tool yet.

![original set'o'gram visualization](/images/paper-0.png)

![original set'o'gram interaction technique](/images/paper-1.png)

There were several starting places to critique the original authors' work when it comes to the base visualization, illustrated in the two images above. First, it appears that green is someone's favorite color since it is the de facto set color with yellow being the only highlight. There is no clear indication why this is, aside from maybe making the visualization stand out from black text in a paper. Additionally, the y-axis information is rotated clockwise instead of the more typical counter-clockwise seen in x-y graphs. It is also the opposite rotation of the x-axis set labels, which makes that more difficult to view simultaneously. The bar graph background is striped with more shades of green, so it does not stand out as effectively from the bars that actually encode the set-typed data. There is an inherent artifact in the original implementation that the authors decide that it encodes more information, but this comes at the risk of occluding data. This occurs when the bar widths move in the opposite direction. Also, the empty set is often shown in their visualizations, which can sometimes be unneeded data. Lastly, the use of the cushion gradient method to highlight multiple blocks results in a color saturation disparity across the bar graph, and the authors even mention that there are other techniques to separate bars in the same column.

As such, several critical design decisions were made for this project:

-  encode each set as separate color to highlight the dissimilarity among sets (this is limited to 8 distinguishable colors for the sets)
-  keep all non-data (labels, axes, numbers, etc.) as black on a white background
-  rotate y-axis text (when necessary) counter-clockwise
-  color the striped background to each bar in a light gray, so the varying widths of bars can still be distinguished while also denoting it in a lack of color
-  do not allow for artifacts to appear to occlude information
-  ignore the empty set in the visualization (for simplfication)
-  opt for a visually cleaner method of encoding the bars with a small white stroked line around each rectangle, so bars can still be distinguished
-  larger focus on interaction due to the focus of creating an interactive legend

![highlight interactions in a set'o'gram with Penn data set](/images/penn-data-0.png)

![highlight the change in interaction display in a set'o'gram when scaling the axis](/images/penn-data-1.png)

Interactions are a very important part of the visualization tool. At the top of the display, the name of the data loaded is seen as the chart title. The data can be changed by simply clicking on the title. Clicking multiple times scrolls through all the available datasets. Right-clicking will scroll through those data-sets backwards to quickly jump to the previous dataset. Like the original authors, a "relative" bar height mode is also available. This is a view where the height of each bar / set is scaled to be the same, thus enabling really tiny block heights to be visible. There is a comparison between these the regular and relative modes in the two images above. Clicking on the set names below the graph will select and highlight (or deselect and unhighlight) that set and also any other set that has a data item in the set that was selected. Hovering over a set name will display the amount of data items associated with that set. Additionally, for each block on the bar graph, there is a similar selection and highlighting technique. Lastly, each block can be hovered over to display the number of data items in that block (with that set overlap frequency) while also highlighting which sets contain the overlap and how much that overlap is for that set, as seen below.

![showing set overlap with a set'o'gram](/images/titanic-data-0.png)


Challenges
----------

There were three key challenges in this project which are actually all interconnected to the confusing nature of set-typed data. The first challenge was finding and classifying data sets for visualizing in the tool. The second challenge was finding a way to store this data to properly represent it. Finally, the last challenge was to connect the raw data to the interactive techniques while avoiding visual clutter and visual artifacts.

To start off the project, one of the Titanic datasets was used, like in this ParSets example. The cardinality of each set was reduced into the following simpler categories: survived, adult, male, first-class. This means that a person is either in each of those sets or not. The data is encoded in a binary fashion: 1 denoting a member of the set, 0 denoting not a member of the set. This is an assumption already on the data and starts to highlight how unique and complicating sets can be. Actually, as it turns out, there are two different datasets for the Titanic survival data, one just has more data points than the other. But, sub-sampling data can even result in different results, compare the two images below to see.

![one Titanic data set as a set'o'gram](/images/titanic-data-1.png)

![an alternative Titanic data set as a set'o'gram](/images/titanic-data-2.png)

Still part of the first challenge, finding datasets is very tricky for set-typed data, and finding more data sets was one of my last steps for the project. For starters, try "Google-ing" the phrase 'set data'. It likely will not give you what you want, especially due to the common search term 'dataset', which is a very unfortunate name in retrospect. Another complicating factor is that most data is numeric, not broken into sets. And then also set data is more often defined in mathematical terms, so finding real-world, non-simple data can be very tricky, indeed. A Python script was created to crawl through some numeric datasets (like the Labor Supply or Penn World Table dataset), and it used manually determined numeric values to classify a data point (like a person or a country) as either a member of a set or not. This can get extremely difficult and time-consuming to find the right way to divide the original data. Inherently, there is interesting information there, but it is difficult to get easily sometimes. A good portion of this project was spent trying to find more data to test out in the tool, to see how it handles in each case.

The next hurdle was encountered earlier on, and this was how to properly store the frequency overlap information. It took many iterations of playing with the tool and data to finally come out with a three-dimensional array that stores all possible frequency overlaps. Even with that, there is redundant data present, unfortunately, but it was able to effectively display the visualization without any significant decrease in the processing and rendering time. Of those three dimensions, the first dimensions stores which set, the second dimensions stores the frequency count over the overlap, and the third dimension stores which sets are part of that frequency overlap. Confused yet? I sure was.

The final hurdle results in the most amount of bugs in the final tool, which is unfortunate. Figuring out  how to interact with the sets on a block-level is very complicated since the highlighting and selection mechanism results in highlighting only parts of blocks. Properly stacking these blocks to avoid overlap is tricky. Rather than jump to a four-dimensional array to store this information, it was opted to keep a simpler approach for the minor visual anomalies that occur when highlighting multiple sets using the "hover over" technique on the blocks. This only happens occasionally, and it does not dramatically effect the usefulness of the current implementation of this tool for the data that was looked at.


Effectiveness & Usefulness
--------------------------

It is difficult to say much about the effectiveness that is not biased. Obviously, to me, this approach seemed more clear and simpler than the set'o'grams in the original paper. It also serves a much different purpose, being constructed as a legend, not one of many different set views used in the tool the authors wrote for their paper. The goal was to create a simple set'o'gram to highlight the data and the overlaps of sets, and this project definitely serves that purpose well.

For usefulness, one key factor is that sets need to have overlaps to make this sort of visualization effective. If there are no overlaps, then the set'o'gram becomes a simple bar graph displaying the count of the items across each disparate set. Not all that unique or even useful. This technique is this used when data points can be associated with multiple elements. As a legend, say if each data point has an additional linked view, it might be useful to know when a single data point is actually a member of multiple sets. There are other methods of showing these relations, but for many data items this becomes very cluttered for most if not all of those methods. More obviously, the data looking to be visualized should be set-typed in nature. Sets can be created arbitrarily from numerical data, so caution is needed when doing so to avoid creating trends from incorrect assumptions of the data. This is yet another reason why set-typed data is both complicating and non-standard.

One confounding factor for this visualization method is how to read the blocks. When the frequency goes to three or more sets, then it can become confusing to identify which sets are interacting together or separately at each data point. There may not even be such a relation. That sort of analysis would require checking each of those sets separately, and this becomes cumbersome using the current interaction techniques employed for highlighting and selecting. This is connected with the simple fact for sets that larger set overlaps get more complicated to compare.

Below is an image of some data from a collaborator that was randomized to protect their data, but it shows how this tool could apply to real-world set-typed data. It definitely has potential in being a simple, but informative, interactive legend.

![set'o'gram for a collaborator's gene data, anonymized](/images/genes-data-0.png)


Extensions
----------

Given more time, it would have been nice to fix the few visual artifacts present in the highlighting of the different blocks across the bars. Exploring set-typed data further, in trying to classify and better understand it, is definitely an avenue for future work. Connecting this interactive legend to another linked spatial view of the data points would enable it to be effectively compared to other existing methods of highlighting data points representing multiple sets, so that is also something that could be done in the near future. My hope is to integrate this tool into some of my work and potentially measure the effectiveness of this method against other methods of comparing data points and which sets they belong to.


Compiling & Running Code
------------------------

download the [Processing v.2.0 IDE](http://processing.org/) 

just open this repository in the IDE to run [*setVis/setVis.pde*](/setVis/setVis.pde)

a [Python script](/script/prepSet.py) is provided as an example of converting a dataset to set-typed data


References
----------

[*Interactive Visual Analysis of Set-Typed Data*](http://www.cg.tuwien.ac.at/research/publications/2008/Freiler-2008-Set/Freiler-2008-Set-paper.pdf)

-  by **Wolfgang Freiler**, **Kresimir Matkovic**, & **Helwig Hauser**

[**Dr. Chris Gregg**](http://www.neuro.utah.edu/people/faculty/gregg.html) for genes dataset (totally anonymized here)

[R (programming language)](http://vincentarelbundock.github.com/Rdatasets/datasets.html) for all other datasets
