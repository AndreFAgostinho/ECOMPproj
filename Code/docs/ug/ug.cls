\LoadClass[twoside,a4paper]{article}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ug}

\RequirePackage{graphicx}
\RequirePackage{helvet}
\RequirePackage{fancyhdr}
%\RequirePackage{fancyvrb}
%\RequirePackage[includehead,includefoot,top=50pt,bottom=50pt,headheight=24pt,margin=1in]{geometry}
\RequirePackage[includehead,includefoot,top=50pt,bottom=50pt,headheight=24pt]{geometry}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{multirow}
\RequirePackage{verbatim}
\RequirePackage{geometry}

\geometry{
 a4paper,
 total={170mm,257mm},
 left=20mm,
 top=20mm,
}

\pagestyle{fancy}
\graphicspath{ {./figures/} {./wavedrom/} }
\setlength{\parskip}{\baselineskip}


\renewcommand{\headrulewidth}{.4pt}
\fancyhead{}
\fancyhead[RO,LE]{
\textbf{\@title}
\\
\textsc{\small{\@category}}
}
\fancyhead[RE,LO]{\includegraphics[scale=.25]{Logo.png}}

\renewcommand{\footruleskip}{10pt}
\renewcommand{\footrulewidth}{.4pt}

\fancyfoot{}
\fancyfoot[LO,RE]{\copyright 2017 IObundle Lda All rights reserved\hspace{1cm}\url{www.iobundle.com}\hspace{1cm}{\bf Confidential}}
\fancyfoot[LE,RO]{\thepage}

\newcommand{\category}[1]{\def\@category{#1}}
\renewcommand{\familydefault}{\sfdefault}

\renewcommand{\maketitle}{
\begin{titlepage}
\setlength{\parindent}{0pt}
\setlength{\parskip}{1ex}
\vspace*{100pt}
\Huge{\textbf{\@title}}

\huge{\@category}

\vspace*{2ex}
\includegraphics[keepaspectratio,scale=.7]{Logo.png}

\small{\today}
\vspace*{\fill}
\end{titlepage}
}
