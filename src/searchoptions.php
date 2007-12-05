<div class="content">


<h2>Search Entire Text</h2>

<form name="belfastquery" action="search.php" method="get">
<table class="searchform" border="0">
<tr><th>Keyword</th><td class="input"><input type="text" size="40" name="keyword" value="<?php print $kw ?>"></td></tr>
<tr><th>Title</th><td class="input"><input type="text" size="40" name="doctitle" value="<?php print $doctitle ?>"></td></tr>
<tr><th>Author</th><td class="input"><input type="text" size="40" name="auth" value="<?php print $auth ?>"></td></tr>
<tr><td></td><td><input type="submit" value="Submit"> <input type="reset" value="Reset"></td></tr>
</table>
</form>



<hr width="60%" align="left">

<p><h4>Search tips:</h4>
<ul>
<li>Searches are <i>not</i> case-sensitive.</li>
<li>Search terms are matched against <i>whole words</i>.<br>
  For example, searching for
<b>america</b> will not match <b>american</b>.</li>

<li>To match part of a word, add an asterisk.<br>
For example, enter <b>driv*</b> to match <b>drive</b>, <b>driving</b>, and
<b>driven</b>.</li>
<li>Multiple words are allowed.<br>
For example, enter <b>South Carolina</b> or <b>far from
satisfactory</b> to match those exact strings.</li>

<li>Asterisks may also be used with multiple words.<br>
For example, enter <b>*th Carolina</b> to match both
<b>North Carolina</b> and <b>South Carolina</b>.</li>
</ul>
</p>

<p>If you are interested in doing a more complex search, please
contact the <a href="mailto:beckcenter@emory.edu">Beck Center
Staff</a>.</p>



</div>