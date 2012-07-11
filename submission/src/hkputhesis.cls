\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hkputhesis}
[2012/06/21 v0.1 The Hong Kong Polytechnic University Thesis class]
\RequirePackage{setspace}
\newcounter{subyear}
\setcounter{subyear}{\number\year}
\def\submitted#1{\gdef\@submitted{#1}}
\def\@submittedyear{\ifnum\month>10 \stepcounter{subyear}\thesubyear
\else\thesubyear\fi}
\def\@submittedmonth{\ifnum\month>10 January\else\ifnum\month>5 November
\else June\fi\fi}
\def\copyrightyear#1{\gdef\@copyrightyear{#1}}
\def\@copyrightyear{\number\year}
\def\adviser#1{\gdef\@adviser{#1}}
\long\def\@abstract{\@latex@error{No \noexpand\abstract given}\@ehc}
\newcommand*{\frontmatter}{
\pagenumbering{Roman}
}
\newcommand*{\mainmatter}{\pagenumbering{arabic}}
\newcommand*{\makelot}{}
\newcommand*{\makelof}{}
\newcommand*{\makelos}{}
\newcommand*{\maketoc}{
  % Add ToC to the pdfbookmarks as a section, but not to the ToC itself.
  % only if we have the hyperref command that is necessary
  \ifdefined\pdfbookmark
  \phantomsection
  \pdfbookmark[0]{\contentsname}{Table of Contents}
  \else
  \fi

  \tableofcontents
  \clearpage
  }
%% Setup a command to add extra space only if in singlespacing mode
\newcommand*{\extravspace}[1]{\vspace{0in}}
%% Setup a command to set spacing for body text; also used to restore spacing after long tables in document
\newcommand*{\bodyspacing}{
\doublespacing
}
%% Setup a command to set spacing for long tables, to be used manually in document
\newcommand*{\tablespacing}{
\singlespacing
}
\newcommand{\minsize}{\fontsize{10pt}{10pt}\selectfont}
\newcommand{\tocchapsize}{\fontsize{12pt}{12pt}\selectfont\bfseries}
\newcommand{\chaptersize}{\fontsize{22pt}{28pt}\selectfont\bfseries}
\newcommand{\sectionsize}{\fontsize{18pt}{22pt}\selectfont\bfseries}
% \subsectionsize also used for heading in abstract, references, etc.
\newcommand{\subsectionsize}{\fontsize{16pt}{20pt}\selectfont\bfseries}
\newcommand{\subsubsectionsize}{\fontsize{14pt}{16pt}\selectfont\bfseries}

%% Command inserted into the document immediately after \begin{document} to place all frontmatter
%%   This was formerly named 'begincmd' and called below in \AtBeginDocument{}
%%   However, that is not compatible with package 'hyperref'. \tableofcontents needs
%%   to be declared from within the document itself.
\newcommand*{\makefrontmatter}{
\bodyspacing
\frontmatter
\maketitlepage
\setcounter{page}{1} % As required, the page number of the authorship statement is I
\makeauthorshipstatement
\makeacknowledgements
\makeabstract
\makededication
\maketoc
\makelof\clearpage
\makelot\clearpage
\makelos\clearpage
\mainmatter
}
\def\@submitted{\@submittedmonth~\@submittedyear}
\def\@polyu{The Hong Kong Polytechnic University}
\def\@dept{Mathematics}
\def\@deptpref{Department of}
\def\departmentprefix#1{\gdef\@deptpref{#1}}
\def\department#1{\gdef\@dept{#1}}
\def\programme#1{\gdef\@programme{#1}}
\long\def\acknowledgements#1{\gdef\@acknowledgements{#1}}
\def\dedication#1{\gdef\@dedication{#1}}
\newcommand{\maketitlepage}{{
\thispagestyle{empty}
\vspace*{1.33in}
\begin{center}
{\subsectionsize\bfseries \@title}
\end{center}
\vspace*{1.57in}
\begin{center}
{\subsectionsize\bfseries \@author}
\end{center}
\vspace*{.8in}
\begin{center}
{\subsectionsize\bfseries \@programme}
\end{center}
\vspace{.47in}
\begin{center}
{\subsectionsize\bfseries \@polyu}
\end{center}
\vspace{.2in}
\extravspace{.3in}
  % \begin{center}
  %     Recommended for Acceptance \\
  %     by the \@deptpref \\
  %     \@dept \\
  %     Adviser: \@adviser
  %   \end{center}
  \vspace{.3in}
  \extravspace{.3in}
  \begin{center}
  {\subsectionsize\bfseries\@submitted}
  \end{center}
  \clearpage
  }}
  \newcommand*{\makeauthorshipstatement}{
  \newpage
  \ifdefined\phantomsection
  % makes hyperref recognize this section properly for pdf links
  \phantomsection
  \else
  \fi
  \addcontentsline{toc}{chapter}{Statement of Authorship}
  \vspace*{-12pt}
  \begin{doublespace}
  {\subsectionsize\bfseries Statement of Authorship}
  \end{doublespace}
  \vspace*{6pt}
  \begin{singlespace}
  Except where reference is made in the text of this dissertation, this dissertation contains no material published elsewhere or extracted in whole or in part from a dissertation presented by me for another degree or diploma.

  No other \text{person's} work has been used without due acknowledgement in the main text of the dissertation.

  This dissertation has not been submitted for the award of any other degree or diploma in any other tertiary institution.

  \vspace{4cm}

  \noindent\rule{.4\linewidth}{0.3pt}

  Name: \@author

  Dated: \ddmmyyyydate \today

  \end{singlespace}
  \clearpage
  }
  \newcommand*{\makeabstract}{
  \newpage
  \ifx\@abstract\undefined
  \else
  \ifdefined\phantomsection
     % makes hyperref recognize this section properly for pdf links
     \phantomsection
     \else
     \fi

     \addcontentsline{toc}{chapter}{Abstract}
     \vspace*{-12pt}
     \begin{doublespace}
     {\subsectionsize\bfseries Abstract}
     \end{doublespace}
     \vspace*{6pt}
     \@abstract
     \clearpage
     \fi
     }
     \def\makeacknowledgements{
     \ifx\@acknowledgements\undefined
     \else
     \ifdefined\phantomsection
     % makes hyperref recognize this section properly for pdf links
     \phantomsection
     \else
     \fi

     \addcontentsline{toc}{chapter}{Acknowledgements}
     \vspace*{-12pt}
     \begin{doublespace}
     {\subsectionsize\bfseries Acknowledgements}
     \end{doublespace}
     \vspace*{6pt}
     \@acknowledgements
     \clearpage
     \fi
     }
     \def\makededication{
     \ifx\@dedication\undefined
     \else
     \vspace*{1.5in}
     \begin{flushright}
     \@dedication
     \end{flushright}
     \clearpage
     \fi
     }
     \DeclareOption{lot}{\renewcommand*{\makelot}{
     \ifdefined\phantomsection
    % makes hyperref recognize this section properly for pdf links
    \phantomsection
    \else
    \fi
    \addcontentsline{toc}{chapter}{List of Tables}\listoftables}}
    \DeclareOption{lof}{\renewcommand*{\makelof}{
    \ifdefined\phantomsection
    % makes hyperref recognize this section properly for pdf links
    \phantomsection
    \else
    \fi
    \addcontentsline{toc}{chapter}{List of Figures}\listoffigures}}
    \DeclareOption{los}{
    \renewcommand*{\makelos}{
    \RequirePackage{losymbol}
    \section*{List of Symbols\@mkboth {LIST OF SYMBOLS}{LIST OF SYMBOLS}}
    \@starttoc{los}
    \ifdefined\phantomsection
    % makes hyperref recognize this section properly for pdf links
    \phantomsection
    \else
    \fi
    \addcontentsline{toc}{chapter}{List of Symbols}
    }
    }
    \DeclareOption{singlespace}{
    \renewcommand*{\bodyspacing}{
    \singlespacing
    }
  %% Add extra space only if in singlespacing mode
  \renewcommand*{\extravspace}[1]{\vspace{#1}}
  }
%% Doublespacing is the default for the thesis -- need not be declared.
\DeclareOption{doublespacing}{
\renewcommand*{\bodyspacing}{
\doublespacing
}
}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
%% Not necessary to specify the point size - we inherit it from above
%% \LoadClass[12pt]{report}
\LoadClass{report}
\setlength{\oddsidemargin}{.5in}   %{.4375in}
\setlength{\evensidemargin}{.5in} %{.4375in}
\setlength{\topmargin}{-.5in}  %{-.5625in}
\setlength{\footskip}{.25in} % to put page number 3/4" from the bottom of the page (1/4" from bottom of body text)
\setlength{\textheight}{9in}
\setlength{\textwidth}{6in}

%%% Alter LaTeX defaults to try to eliminate all widows and orphans
\clubpenalty=10000
\widowpenalty=10000

%%% try to avoid overfull lines by limiting how far it is okay to exceed the margins
%%% http://www.tex.ac.uk/cgi-bin/texfaq2html?label=overfull
\setlength{\emergencystretch}{2em}

\long\def\abstract#1{\gdef\@abstract{#1}}
%% 'begincmd' no longer used -- insert \makefrontmatter in the document instead. See above.
%\AtBeginDocument{\begincmd}
\endinput


%%
%% End of file `hkputhesis.cls'.
