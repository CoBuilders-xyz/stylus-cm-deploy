!!! info "Archived documentation"

    This page is retained as historical reference. For the current Stylus Manager release, use the [activation, caching, and deployment guides](../../index.md). Commands and architecture in archived notes may describe earlier versions.

# Mk Cheatsheet

!!! example "Example Title"

    Different Admonitions Available


      - note
      - abstract
      - info
      - tip
      - success 
      - question 
      - warning
      - failure
      - danger
      - bug
      - example
      - quote

!!! tip "This is a tip"

    Tip

??? tip "This is a collapsable tip!"

    Collapsable Tip

This is an annotation, (1)
{ .annotate }

1.  :man_raising_hand: I'm an annotation! I can contain `code`, __formatted
    text__, images, ... basically anything that can be expressed in Markdown.


Code Block
``` { .yaml }
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment

```

Code Block With Tabs
=== "C"

    ``` c
    #include <stdio.h>

    int main(void) {
      printf("Hello world!\n");
      return 0;
    }
    ```

=== "C++"

    ``` c++
    #include <iostream>

    int main(void) {
      std::cout << "Hello world!" << std::endl;
      return 0;
    }
    ```