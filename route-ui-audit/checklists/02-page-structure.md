# 2. Page structure — template, page top, toolbars

## 2a. Page template

- [ ] The page is assigned to a documented page type
- [ ] It follows that page type's defined structure
- [ ] Page width and alignment match the system
- [ ] Header, content and footer regions use standard spacing
- [ ] The page starts at the expected vertical position
- [ ] Related pages feel like members of the same family
- [ ] Differences from the standard template are intentional **and documented**
- [ ] The route does not introduce an undocumented page pattern

Compare side by side with its siblings of the same page type. Inconsistency between two collection pages is invisible one route at a time.

## 2b. Page top

Every page top follows a written anatomy. Default order:

`Context → Title and status → Flexible space → Secondary actions → Primary action → Overflow`

- [ ] Breadcrumb or back navigation appears where required
- [ ] Page title uses the correct type style and position
- [ ] Subtitle, metadata or status uses the standard pattern
- [ ] Primary action is clearly identifiable
- [ ] Secondary actions use the expected hierarchy
- [ ] Destructive actions are separated or moved into an overflow menu
- [ ] Actions appear in a consistent order across routes
- [ ] The header contains no one-off button arrangement
- [ ] Long titles and translated text don't break the layout — test with a real long value
- [ ] Mobile behavior is defined: wrap, collapse, overflow or stack

## 2c. Toolbars and action rows

- [ ] A shared toolbar component or documented composition is used
- [ ] Search appears in the standard location
- [ ] Search behavior is consistent across routes (debounce, submit-on-enter, clear)
- [ ] Filters use the same controls and placement
- [ ] Active filters are visible and removable
- [ ] "Clear all" exists where multiple filters can accumulate
- [ ] Result count is displayed consistently
- [ ] Sort controls follow the same pattern
- [ ] Bulk actions appear only after selection
- [ ] Primary and destructive actions are visually distinct
- [ ] Button sizes, gaps, icons and labels are consistent
- [ ] The toolbar has defined wrapping or overflow behavior
- [ ] Controls don't jump when results load — watch the layout during the fetch
- [ ] Keyboard focus order stays logical

## Evidence to capture

Screenshot the page top and toolbar of every route of the same page type, side by side. That single comparison usually produces half the findings.
